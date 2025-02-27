import 'package:flutter/material.dart';
import 'book_reader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Sprout"),
        backgroundColor: Colors.lightGreen[200],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
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
      body: const BookGrid(),
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
          // Drawer Header with Close Button
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
                  right: 1, // Adjust as needed to align with เมนู
                  top: 0,  // Move up slightly if needed
                  bottom: 0, // Center vertically
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
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
        ],
      ),
    );
  }
}


class BookGrid extends StatelessWidget {
  const BookGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> books = [
      {"title": "มาดูสิ", "image": "assets/madoosi.jpg", "pdf": "assets/madoosi.pdf"},
      {"title": "หมูหวานฟันผุ", "image": "assets/moowhan.jpg", "pdf": "assets/moowhan.pdf"},
      {"title": "ชูใจชอบแปรงฟัน", "image": "assets/chujai.jpg", "pdf": "assets/chujai.pdf"},
      {"title": "หมูเล็กไม่กินผัก", "image": "assets/mhoolek.jpg", "pdf": "assets/mhoolek.pdf"},
      {"title": "ของหาย", "image": "assets/lostandfound.jpg", "pdf": "assets/lostandfound.pdf"},
      {"title": "หนูจี๊ดติดจอ", "image": "assets/nujit.jpg", "pdf": "assets/nujit.pdf"},
      {"title": "เละเทะ", "image": "assets/laetae.jpg", "pdf": "assets/laetae.pdf"},
    ];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 books per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlipBookPage(
                    title: books[index]["title"]!,
                    pdfPath: books[index]["pdf"]!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: books[index]["image"]!.isNotEmpty
                        ? Image.asset(books[index]["image"]!, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text("No Image", style: TextStyle(fontSize: 14)),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      books[index]["title"]!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}