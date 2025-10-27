import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  
  /// جلب كتاب واحد بناءً على الاستعلام
  static Future<BookModel?> fetchBookByQuery(String query) async {
    try {
      final url = '$_baseUrl?q=${Uri.encodeComponent(query)}';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          return BookModel.fromJson(data['items'][0]);
        }
      }
      return null;
    } catch (e) {
      print('خطأ في جلب الكتاب: $e');
      return null;
    }
  }

  /// جلب عدة كتب بناءً على قائمة استعلامات
  static Future<List<BookModel>> fetchBooksByQueries(List<String> queries) async {
    try {
      final responses = await Future.wait(
        queries.map((query) => fetchBookByQuery(query))
      );
      
      return responses.where((book) => book != null).cast<BookModel>().toList();
    } catch (e) {
      print('خطأ في جلب الكتب: $e');
      return [];
    }
  }

  /// جلب كتاب بالمعرف
  static Future<BookModel?> fetchBookById(String bookId) async {
    try {
      final url = '$_baseUrl/$bookId';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BookModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('خطأ في جلب الكتاب بالمعرف: $e');
      return null;
    }
  }

  /// البحث في الكتب
  static Future<List<BookModel>> searchBooks(String searchQuery, {int maxResults = 10}) async {
    try {
      final url = '$_baseUrl?q=${Uri.encodeComponent(searchQuery)}&maxResults=$maxResults';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          return data['items']
              .map<BookModel>((item) => BookModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('خطأ في البحث: $e');
      return [];
    }
  }
}
