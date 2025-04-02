import 'package:flutter/material.dart'; 
import 'package:storybook_app/models/question.dart';
import 'package:storybook_app/services/api_service.dart';

class QuizPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final int pageNumber;
  final bool doublePage;

  QuizPage({
    required this.bookId,
    required this.bookTitle,
    required this.pageNumber,
    this.doublePage = false
  });


  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> allQuestions = [];
  List<Question> questionsForPage = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerSelected = false;
  bool isLoading = true;

  @override
  void initState() {
  super.initState();
  print("📥 Loading questions for bookId=${widget.bookId}, page=${widget.pageNumber}");
  loadQuestionsFromBackend();
}
    
    

 void loadQuestionsFromBackend() async {
  try {
    final questions = await ApiService.fetchQuestionsByBookId(widget.bookId);
    print("✅ ได้คำถามทั้งหมด: ${questions.length}");

    setState(() {
      allQuestions = questions;
      questionsForPage = widget.doublePage
          ? allQuestions.where((q) =>
              q.pageNumber == widget.pageNumber ||
              q.pageNumber == widget.pageNumber + 1).toList()
          : allQuestions.where((q) => q.pageNumber == widget.pageNumber).toList();

      print("📄 หน้านี้มีคำถาม: ${questionsForPage.length}");
      isLoading = false;
    });
  } catch (e) {
    print("❌ Error loading questions: $e");
    setState(() {
      isLoading = false;
    });
  }
}

  void checkAnswer(int selectedIndex) {
    if (isAnswerSelected) return;

    final currentQuestion = questionsForPage[currentQuestionIndex];

    setState(() {
      isAnswerSelected = true;
    });

    if (currentQuestion.type == 'choice' &&
      selectedIndex == currentQuestion.answerIndex) {
    score++;
  }

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < questionsForPage.length - 1) {
        setState(() {
          currentQuestionIndex++;
          isAnswerSelected = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("จบเกม!"),
            content: Text("คุณได้คะแนน $score/${questionsForPage.length}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestionIndex = 0;
                    score = 0;
                    isAnswerSelected = false;
                  });
                },
                child: Text("เล่นอีกครั้ง"),
              )
            ],
          ),
        );
      }
    });
  }
  int _countScorableQuestions() {
  return questionsForPage.where((q) => q.type == 'choice').length;
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("โหลดคำถาม...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questionsForPage.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("เกมควิซ")),
        body: Center(child: Text("ไม่มีคำถามสำหรับหน้านี้")),
      );
    }

    final currentQuestion = questionsForPage[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("เกมควิซ")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("คำถามที่ ${currentQuestionIndex + 1}/${questionsForPage.length}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(currentQuestion.question, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...List.generate(currentQuestion.options.length, (index) {
              return ElevatedButton(
                onPressed: isAnswerSelected ? null : () => checkAnswer(index),
                child: Text(currentQuestion.options[index]),
              );
            }),
          ],
        ),
      ),
    );
  }
}