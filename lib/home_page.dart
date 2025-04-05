import 'package:flutter/material.dart';
import 'book_reader.dart';
import 'game_menu_page.dart';
import 'package:storybook_app/models/question.dart';
import 'package:storybook_app/services/api_service.dart';
import 'package:storybook_app/models/book.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Sprout"),
        backgroundColor: Colors.lightGreen[200],
        actions: [
          IconButton(
            icon: Icon(Icons.videogame_asset, size: 30, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameMenuPage()),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Icon(Icons.account_circle, size: 30),
                SizedBox(width: 5),
                Text("Please Login", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const BookListView(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(color: Color(0xFFC3C3A3)),
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    "เมนู",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, size: 26),
            title: const Text('หน้าแรก', style: TextStyle(fontSize: 18)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history, size: 26),
            title: const Text('อ่านล่าสุด', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.pink, size: 26),
            title: const Text('นิทานที่ชอบ', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, size: 26),
            title: const Text('ที่บันทึกไว้', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            leading: Icon(Icons.videogame_asset, size: 26, color: Colors.blue),
            title: Text('เล่นเกม', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameMenuPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BookListView extends StatefulWidget {
  const BookListView({super.key});
   @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  Map<String, List<Book>> groupedBooks = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final books = await ApiService.getBooks();
    Map<String, List<Book>> temp = {
      "3 ขวบขึ้นไป": [],
      "4–5 ขวบขึ้นไป": [],
      "6–7 ขวบ": [],
    };

    for (var book in books) {
      if (book.ageGroup == 3) {
        temp["3 ขวบขึ้นไป"]!.add(book);
      } else if (book.ageGroup == 4 || book.ageGroup == 5) {
        temp["4–5 ขวบขึ้นไป"]!.add(book);
      } else if (book.ageGroup == 6 || book.ageGroup == 7) {
        temp["6–7 ขวบ"]!.add(book);
      }
    }

    setState(() {
      groupedBooks = temp;
      isLoading = false;
    });
  
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedBooks.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 153, 230),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "เหมาะสำหรับเด็กอายุ ${entry.key}  ",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: 2, height: 20, color: Colors.black26),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final book = entry.value[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            print("👉 เปิดหนังสือ: ${book.title} | ID: ${book.id}");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlipBookPage(
                                  bookId: book.id,
                                  title: book.title,
                                  pdfPath: book.pdfFile,
                                  bookSlug: book.bookSlug,
                                  doublePage: book.doublePage,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // ✅ ป้องกันการใช้พื้นที่เกินไป
                              children: [
                                Expanded( // ✅ ทำให้รูปไม่ดันขนาดของ Column
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      book.coverImage,
                                      width: 220,
                                      height: 200,
                                      fit: BoxFit.cover, // ✅ ปรับให้ภาพพอดีกับขนาดที่กำหนด
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 226, 240, 198),
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
