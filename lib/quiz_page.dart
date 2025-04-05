import 'package:flutter/material.dart'; 
import 'package:storybook_app/models/question.dart';
import 'package:storybook_app/services/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final int pageNumber;
  final bool doublePage;
  final String? imageAssetPath;

  QuizPage({
    required this.bookId,
    required this.bookTitle,
    required this.pageNumber,
    this.doublePage = false,
    this.imageAssetPath,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> allQuestions = [];
  List<Question> questionsForPage = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerSelected = false;
  bool isLoading = true;
  bool showCorrectLottie = false;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    loadQuestionsFromBackend();
  }

  Future<void> loadQuestionsFromBackend() async {
    try {
      final questions = await ApiService.fetchQuestionsByBookId(widget.bookId);
      setState(() {
        allQuestions = questions;
        questionsForPage = widget.doublePage
            ? allQuestions.where((q) =>
                q.pageNumber == widget.pageNumber ||
                q.pageNumber == widget.pageNumber + 1).toList()
            : allQuestions.where((q) => q.pageNumber == widget.pageNumber).toList();
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading questions: $e");
      setState(() => isLoading = false);
    }
  }

  void checkAnswer(int selectedIndex) {
    if (isAnswerSelected) return;

    final currentQuestion = questionsForPage[currentQuestionIndex];
    final isCorrect = selectedIndex == currentQuestion.answerIndex;

    setState(() {
      isAnswerSelected = true;
      selectedAnswerIndex = selectedIndex;
      if (isCorrect) {
        score++;
        showCorrectLottie = true;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (isCorrect) {
        if (currentQuestionIndex < questionsForPage.length - 1) {
          setState(() {
            currentQuestionIndex++;
            isAnswerSelected = false;
            showCorrectLottie = false;
            selectedAnswerIndex = null;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("จบเกม!"),
                content: Text("คุณได้คะแนน $score/${_countScorableQuestions()}"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("เสร็จสิ้น"),
                  )
                ],
              ),
            );
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 300), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("ลองใหม่อีกครั้ง!"),
              content: const Text("คำตอบไม่ถูกต้อง ลองใหม่ดูนะ 😊"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isAnswerSelected = false;
                      selectedAnswerIndex = null;
                    });
                  },
                  child: const Text("เริ่มใหม่"),
                )
              ],
            ),
          );
        });
      }
    });
  }

  int _countScorableQuestions() {
    return questionsForPage.where((q) => q.type == 'choice').length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questionsForPage.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("ไม่มีคำถามสำหรับหน้านี้")),
      );
    }

    final currentQuestion = questionsForPage[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(title: const Text("คำถามน่ารู้")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildQuestionArea(currentQuestion)),
                      if (widget.imageAssetPath != null)
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.deepPurple.shade100, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              widget.imageAssetPath!,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(child: _buildOptionsArea(currentQuestion)),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildQuestionArea(currentQuestion),
                        const SizedBox(height: 24),
                        _buildOptionsArea(currentQuestion),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionArea(Question currentQuestion) {
    return Column(
      children: [
        if (showCorrectLottie)
          Lottie.asset('assets/animations/correct_check.json', width: 120, repeat: false),
        if (!isAnswerSelected && !showCorrectLottie)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Lottie.asset(
              'assets/animations/ques_thinking.json',
              width: 120,
              repeat: true,
            ),
          ),
        Card(
          color: Colors.yellow.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                currentQuestion.question,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsArea(Question currentQuestion) {
    if (currentQuestion.options.isEmpty ||
        currentQuestion.options.length == 1 && currentQuestion.options.first.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: List.generate(currentQuestion.options.length, (index) {
        Color bgColor = Colors.white;
        if (isAnswerSelected &&
            selectedAnswerIndex == index &&
            selectedAnswerIndex != currentQuestion.answerIndex) {
          bgColor = Colors.red.shade100;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: ListTile(
            leading: const Icon(Icons.circle, color: Colors.deepPurple),
            title: Text(currentQuestion.options[index], style: const TextStyle(fontSize: 25)),
            onTap: isAnswerSelected ? null : () => checkAnswer(index),
          ),
        );
      }),
    );
  }
}