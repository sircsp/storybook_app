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

  QuizPage({
    required this.bookId,
    required this.bookTitle,
    required this.pageNumber,
    this.doublePage = false
  });

@override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  //final AudioPlayer _player = AudioPlayer();
  List<Question> allQuestions = [];
  List<Question> questionsForPage = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerSelected = false;
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
  super.initState();
  _animationController = AnimationController(vsync: this);
  print("📥 Loading questions for bookId=${widget.bookId}, page=${widget.pageNumber}");
  loadQuestionsFromBackend();
}
@override
  void dispose() {
  //  _player.dispose();
    _animationController.dispose();
    super.dispose();
  }

 // void playQuestionSound(String filename) async {
  //  try {
  //    await _player.stop();
  //    await _player.play(AssetSource('sounds/questions/$filename.mp3'));
  //  } catch (e) {
  //    print("⚠️ Failed to play sound: $e");
 //   }
//  }
 

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
   // if (questionsForPage.isNotEmpty) {
      //  playQuestionSound("q1.mp3"); // เริ่มเล่นคำถามแรก
    //  }

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

  // ให้คะแนนเฉพาะ type == 'choice'
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
          content: Text("คุณได้คะแนน $score/${_countScorableQuestions()}"),
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(

          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.yellow.shade100,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.question_mark_rounded, size: 32, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentQuestion.question,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                ),
              ),
            SizedBox(height: 20),
            ...List.generate(currentQuestion.options.length, (index) {
              bool isCorrect = currentQuestion.answerIndex == index;
              return Card(
                color: isAnswerSelected
                    ? (isCorrect
                        ? Colors.green.shade100
                        : Colors.red.shade100)
                    : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: isAnswerSelected ? null : () => checkAnswer(index),
                  leading: Icon(Icons.circle, color: Colors.purple),
                  title: Text(currentQuestion.options[index],
                      style: TextStyle(fontSize: 16)),
                ),
              );
            }),
          ],
        ),
      ),
      ),
    );
  }
}