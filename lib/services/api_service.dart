import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storybook_app/models/book.dart';
import 'package:storybook_app/models/question.dart';

class ApiService {
  //static const String baseUrl = 'http://172.20.10.3:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Book>> getBooks() async {
    print("Requesting books from: $baseUrl/books/");

    final response = await http.get(Uri.parse('$baseUrl/books/'));
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
    print("Fetching questions for book ID: $bookId");
    final response = await http.get(Uri.parse('$baseUrl/questions/?book_id=$bookId'));
    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)); 
      print("Questions loaded: ${data.length}");
      for (var item in data) {
        print("📦 ${item['question']} | page=${item['page']}");
      }

      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      print("Failed to load questions: ${response.body}");
      throw Exception('Failed to load questions');
    }
  }
  static Future<List<Question>> fetchQuestionsByBookSlug(String bookSlug) async {
    print("Fetching questions for book slug: $bookSlug");
    final response = await http.get(Uri.parse('$baseUrl/questions/?book_slug=$bookSlug'));
    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      print("Questions loaded: ${data.length}");
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      print("Failed to load questions: ${response.body}");
      throw Exception('Failed to load questions');
    }
  }
static Future<int> fetchTotalPages(String slug) async {
  final encodedSlug = Uri.encodeComponent(slug);
  final url = '$baseUrl/books/$encodedSlug/pages/';
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