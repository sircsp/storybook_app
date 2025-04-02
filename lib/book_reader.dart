import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'quiz_page.dart';
import 'package:storybook_app/models/question.dart';
import 'package:storybook_app/services/api_service.dart';
import 'dart:io';

class FlipBookPage extends StatefulWidget {
  final int bookId;
  final String title;
  final String pdfPath;
  final String bookSlug;
  final bool doublePage;

  const FlipBookPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.pdfPath,
    required this.bookSlug,
    required this.doublePage,
  });

  @override
  State<FlipBookPage> createState() => _FlipBookPageState();
}

class _FlipBookPageState extends State<FlipBookPage> {
  int currentPage = 1;
  int totalPages = 0;
  List<Question> allQuestions = [];

  @override
  
  void initState() {
    super.initState();
    fetchQuestions();
    _loadTotalPages();
    print("📘 Slug ที่ใช้โหลด totalPages: ${widget.bookSlug}");
  }
  Future<void> _loadTotalPages() async {
    try {
      final pages = await ApiService.fetchTotalPages(widget.bookSlug);
      setState(() {
        totalPages = pages;
      });
      print("📄 โหลดจำนวนหน้าสำเร็จ: $totalPages หน้า");
    } catch (e) {
      print("❌ ไม่สามารถโหลดจำนวนหน้า: $e");
    }
  }

  Future<void> fetchQuestions() async {
    try {
      final questions = await ApiService.fetchQuestionsByBookId(widget.bookId);
      setState(() {
        allQuestions = questions;
      });
      print("✅ ได้คำถามทั้งหมด: ${questions.length}");
    } catch (e) {
      print("❌ Error loading questions: $e");
    }
  }

  bool hasQuizForCurrentPage() {
    return allQuestions.any((q) => q.pageNumber == currentPage);
  }

  String getImageUrl(String slug, int pageNumber) {
    final ip = Platform.isAndroid ? '10.0.2.2' : '172.20.10.3'; // เปลี่ยน IP ตามที่เครื่องคุณได้จาก `ipconfig`
    final paddedPage = pageNumber.toString().padLeft(2, '0');
    return 'http://$ip:8000/static/storybook_pages/$slug/page_$paddedPage.jpg';
}

 @override
  Widget build(BuildContext context) {
    if (totalPages == 0) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: widget.doublePage
          ? _buildDoublePageView()
          : _buildSinglePageView(),
    );
  }



  // ---------- หน้าเดียว ----------
Widget _buildSinglePageView() {
  final imageUrl = getImageUrl(widget.bookSlug, currentPage);

  print("👉 เปิดหนังสือ: ${widget.title} | ID: ${widget.bookId} | SLUG: ${widget.bookSlug}");

  return Stack(
    children: [
      Center(child: Image.network(imageUrl, fit: BoxFit.contain)),
      _buildNavigationButtons(single: true),
      if (hasQuizForCurrentPage()) _buildQuizButton(),
    ],
  );
}

  // ---------- หน้าคู่ ----------
Widget _buildDoublePageView() {
  final leftUrl = getImageUrl(widget.bookSlug, currentPage);
  final rightUrl = getImageUrl(widget.bookSlug, currentPage + 1);

  print("📖 doublePage: ${widget.doublePage}");
  

  return Stack(
    children: [
      Row(
        children: [
          Expanded(child: Image.network(leftUrl, fit: BoxFit.contain)),
          if (currentPage + 1 <= totalPages)
            Expanded(child: Image.network(rightUrl, fit: BoxFit.contain)),
        ],
      ),
      _buildNavigationButtons(single: false),
      if (hasQuizForCurrentPage()) _buildQuizButton(),
    ],
  );
}

  Widget _buildNavigationButtons({required bool single}) {
    return Stack(
      children: [
        if (currentPage > 1)
          Positioned(
            left: 20,
            bottom: MediaQuery.of(context).size.height * 0.5 - 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = single
                      ? currentPage - 1
                      : (currentPage - 2).clamp(1, totalPages);
                });
              },
              child: _buildNavButton(Icons.arrow_back),
            ),
          ),
        if (currentPage < totalPages)
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.5 - 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = single
                      ? currentPage + 1
                      : (currentPage + 2).clamp(1, totalPages);
                });
              },
              child: _buildNavButton(Icons.arrow_forward),
            ),
          ),
      ],
    );
  }



  // ---------- ปุ่ม Quiz ----------
  Widget _buildQuizButton() {
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          print("📤 เปิด QuizPage | bookId=${widget.bookId}, page=$currentPage");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                bookId: widget.bookId,
                bookTitle: widget.title,
                pageNumber: currentPage,
                doublePage: widget.doublePage,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Icon(Icons.quiz, size: 30, color: Colors.purple),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Icon(icon, size: 40, color: Colors.white),
    );
  }
}

   