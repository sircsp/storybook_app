import 'package:flutter/material.dart';
import 'book_reader.dart';
import 'game_menu_page.dart'; // เพิ่มหน้าเลือกเกม

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
          IconButton(
            icon: Icon(Icons.videogame_asset, size: 30, color: Colors.black54), // 🎮 ปุ่มเล่นเกม
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
      body: const BookGrid(),
    );
  }
}

// 🔹 Drawer Menu
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
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
          ListTile(
            leading: Icon(Icons.videogame_asset, size: 26, color: Colors.blue), // 🎮 เมนูเล่นเกม
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

// 🔹 Book Grid (แสดงหนังสือ)
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
      {"title": "หอมนิลอยากมีเพื่อน", "image": "assets/homnil.jpg", "pdf": "assets/homnil.pdf"},
    ];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 เล่มต่อแถว
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65, // ✅ ปรับอัตราส่วนให้รองรับทุกปก
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 ใช้ FittedBox เพื่อให้รองรับทุกอัตราส่วน
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: FittedBox(
                        fit: BoxFit.fill, // ✅ ปรับให้ปกเต็มพื้นที่โดยไม่ถูกตัด
                        child: Image.asset(
                          books[index]["image"]!,
                          width: 150, // ✅ กำหนดความกว้างมาตรฐาน
                          height: 220, // ✅ กำหนดความสูงมาตรฐาน
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0), // ✅ เอา padding ออก ให้แนบสนิทกับกรอบของหนังสือ
                    child: Container(
                      width: double.infinity, // ✅ ทำให้กล่องเต็มความกว้างของ Grid
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 240, 198), // ✅ พื้นหลังสีอ่อนสบายตา
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10), // ✅ ทำให้ขอบมนด้านล่าง
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(color: const Color.fromARGB(255, 151, 236, 201), width: 1), // ✅ ขอบสีอ่อน
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(66, 151, 236, 201),
                            offset: Offset(0, 2), // ✅ เงาล่างให้ดูมีมิติ
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6), // ✅ ให้กล่องไม่สูงเกินไป
                      alignment: Alignment.center, // ✅ จัดให้อยู่ตรงกลางพอดี
                      child: Text(
                        books[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 20, // ✅ ปรับขนาดให้เหมาะสม
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // ✅ สีตัวหนังสือชัดขึ้น
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
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