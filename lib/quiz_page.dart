import 'package:flutter/material.dart';
import 'questions_data.dart'; // ✅ Import คำถามมาใช้

class QuizPage extends StatefulWidget {
  final String bookTitle;
  final int pageNumber;

  QuizPage({required this.bookTitle, required this.pageNumber});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerSelected = false;
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    
    if (widget.bookTitle == "เกมทั่วไป") {
      // ✅ ถ้ามาจากเมนูเกม → ใช้คำถามทั่วไป
      questions = [
        {
          "question": "สัตว์ชนิดใดร้อง เมี้ยว เมี้ยว?",
          "options": ["สุนัข", "แมว", "ช้าง", "นก"],
          "answerIndex": 1
        },
        {
          "question": "สีอะไรคือสีของท้องฟ้า?",
          "options": ["แดง", "เหลือง", "น้ำเงิน", "เขียว"],
          "answerIndex": 2
        },
      ];
    } else {
      // ✅ ถ้ามาจาก FlipBookPage → โหลดคำถามของหนังสือ
      questions = bookQuestions[widget.bookTitle]?[widget.pageNumber] ?? [];
    }
  }

  void checkAnswer(int selectedIndex) {
    if (isAnswerSelected) return;

    setState(() {
      isAnswerSelected = true;
    });

    if (questions[currentQuestionIndex]["type"] == "choice" &&
        selectedIndex == questions[currentQuestionIndex]["answerIndex"]) {
      score++;
    }

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          isAnswerSelected = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("จบเกม!"),
            content: Text("คุณได้คะแนน $score/${questions.length}"),
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

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("เกมควิซ")),
        body: Center(child: Text("ไม่มีคำถามสำหรับหน้านี้")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("เกมควิซ")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("คำถามที่ ${currentQuestionIndex + 1}/${questions.length}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(questions[currentQuestionIndex]["question"], style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...List.generate(questions[currentQuestionIndex]["options"].length, (index) {
              return ElevatedButton(
                onPressed: isAnswerSelected ? null : () => checkAnswer(index),
                child: Text(questions[currentQuestionIndex]["options"][index]),
              );
            }),
          ],
        ),
      ),
    );
  }
}