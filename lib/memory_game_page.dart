import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // ✅ Import สำหรับจัดการหน้าจอแนวตั้ง

class MemoryGamePage extends StatefulWidget {
  @override
  _MemoryGamePageState createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> allCards = ["🐱", "🐶", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"];
  List<String> cards = [];
  List<bool> cardFlipped = [];
  List<int> selectedCards = [];
  bool isChecking = false;
  int totalCards = 6;
  int gridCount = 3;

  @override
  void initState() {
    super.initState();

    // ✅ Fix หน้าจอเป็นแนวตั้งเมื่อเข้าเกม
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _setDifficulty(6);
  }

  @override
  void dispose() {
    // ✅ คืนค่าการหมุนหน้าจอกลับเป็นปกติเมื่อออกจากเกม
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _setDifficulty(int cardCount) {
    List<String> tempCards = allCards.sublist(0, cardCount ~/ 2);
    tempCards = [...tempCards, ...tempCards];
    tempCards.shuffle();
    setState(() {
      cards = tempCards;
      cardFlipped = List.filled(cards.length, false);
      totalCards = cardCount;
    });
  }

  void flipCard(int index) {
    if (!isChecking && !cardFlipped[index]) {
      setState(() {
        cardFlipped[index] = true;
        selectedCards.add(index);
      });

      if (selectedCards.length == 2) {
        isChecking = true;
        Timer(Duration(seconds: 1), checkMatch);
      }
    }
  }

  void checkMatch() {
    if (cards[selectedCards[0]] != cards[selectedCards[1]]) {
      setState(() {
        cardFlipped[selectedCards[0]] = false;
        cardFlipped[selectedCards[1]] = false;
      });
    }
    selectedCards.clear();
    isChecking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เกมจับคู่คำศัพท์")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDifficultyButton("ง่าย", 6),
                SizedBox(width: 10),
                _buildDifficultyButton("ปานกลาง", 12),
                SizedBox(width: 10),
                _buildDifficultyButton("ยาก", 16),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double spacing = 12.0;
                int gridCount = (totalCards == 6) ? 3 : (totalCards == 12) ? 4 : 4;
                double cardSize = (constraints.maxWidth - (gridCount + 1) * spacing) / gridCount;

                return GridView.builder(
                  padding: EdgeInsets.all(spacing),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => flipCard(index),
                      child: Container(
                        width: cardSize,
                        height: cardSize,
                        decoration: BoxDecoration(
                          color: cardFlipped[index] ? Colors.white : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                        ),
                        child: Center(
                          child: Text(
                            cardFlipped[index] ? cards[index] : "❓",
                            style: TextStyle(fontSize: 32, color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String label, int cardCount) {
    return ElevatedButton(
      onPressed: () => _setDifficulty(cardCount),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Colors.orange,
        textStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }
}