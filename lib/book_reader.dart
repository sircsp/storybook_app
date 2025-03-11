import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'quiz_page.dart';
import 'questions_data.dart';

class FlipBookPage extends StatefulWidget {
  final String title;
  final String pdfPath;

  const FlipBookPage({super.key, required this.title, required this.pdfPath});

  @override
  State<FlipBookPage> createState() => _FlipBookPageState();
}

class _FlipBookPageState extends State<FlipBookPage> {
  late PdfViewerController _pdfViewerController;
  bool _isError = false;
  int currentPage = 1;



  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  // ✅ ตรวจสอบว่าหน้านี้มีควิซหรือไม่
  bool hasQuizForCurrentPage() {
    return bookQuestions.containsKey(widget.title) &&
        bookQuestions[widget.title]!.containsKey(currentPage);
  }
  

  @override
  Widget build(BuildContext context) {
    bool isQuizPage = hasQuizForCurrentPage();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          SfPdfViewer.asset(
            widget.pdfPath,
            pageLayoutMode: PdfPageLayoutMode.single,
            controller: _pdfViewerController,
            onPageChanged: (details) {
              setState(() {
                currentPage = details.newPageNumber;
              });
            },
          ),

          // 🔹 ปุ่มย้อนกลับ (ซ้าย)
          Positioned(
            left: 20,
            bottom: MediaQuery.of(context).size.height * 0.5 - 30,
            child: GestureDetector(
              onTap: () => _pdfViewerController.previousPage(),
              child: _buildNavButton(Icons.arrow_back),
            ),
          ),

          // 🔹 ปุ่มไปข้างหน้า (ขวา)
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.5 - 30,
            child: GestureDetector(
              onTap: () => _pdfViewerController.nextPage(),
              child: _buildNavButton(Icons.arrow_forward),
            ),
          ),

          // 🔹 ปุ่มเล่นควิซ (เฉพาะหน้าที่มีควิซ)
          if (isQuizPage)
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(
                        bookTitle: widget.title,
                        pageNumber: currentPage,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Icon(Icons.quiz, size: 30, color: Colors.purple),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 ฟังก์ชันสร้างปุ่มนำทาง
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