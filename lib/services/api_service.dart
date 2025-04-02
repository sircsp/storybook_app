import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storybook_app/models/book.dart';
import 'package:storybook_app/models/question.dart';
import 'dart:io';

class ApiService {
  static String getBaseUrl() {
    // ตรวจ platform แล้วเลือก IP ที่ถูกต้อง
    if (Platform.isAndroid || Platform.isIOS) {
      return 'http://172.20.10.3:8000/api'; // <== IP ของ Mac
    } else {
      return 'http://10.0.2.2:8000/api'; // สำหรับ emulator
    }
  }

  static Future<List<Book>> getBooks() async {
    final url = '${getBaseUrl()}/books/';
    print("Requesting books from: $url");

    final response = await http.get(Uri.parse('${getBaseUrl()}/books/'));
    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print("Books loaded: ${data.length}");
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      print("Failed to load books: ${response.body}");
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Question>> fetchQuestionsByBookId(int bookId) async {
    final url = '${getBaseUrl()}/questions/?book_id=$bookId';
    print("Fetching questions from: $url");

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)); 
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<List<Question>> fetchQuestionsByBookSlug(String bookSlug) async {
    final url = '${getBaseUrl()}/questions/?book_slug=$bookSlug';
    print("Fetching questions from: $url");

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<int> fetchTotalPages(String slug) async {
    final encodedSlug = Uri.encodeComponent(slug);
    final url = '${getBaseUrl()}/books/$encodedSlug/pages/';
    print("📥 Loading total pages from: $url");

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['total_pages'];
    } else {
      throw Exception('Failed to fetch total pages');
    }
  }
}