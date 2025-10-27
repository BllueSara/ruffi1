import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../services/book_service.dart';

class HomeController extends ChangeNotifier {
  String _selectedCategory = 'الكل';
  Map<String, List<BookModel>> _booksByCategory = {
    'الروايات': [],
    'تطوير الذات': [],
    'علم النفس': [],
    'الكل': [],
  };
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get selectedCategory => _selectedCategory;
  Map<String, List<BookModel>> get booksByCategory => _booksByCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<BookModel> get currentBooks => _booksByCategory[_selectedCategory] ?? [];
  List<CategoryModel> get categories => CategoryModel.getDefaultCategories();

  /// تغيير التصنيف المحدد
  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// جلب الكتب من الخدمة
  Future<void> fetchBooks() async {
    _setLoading(true);
    _clearError();

    try {
      final categories = CategoryModel.getDefaultCategories();
      
      for (var category in categories) {
        final books = await BookService.fetchBooksByQueries(category.searchQueries);
        _booksByCategory[category.displayName] = books;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('خطأ في جلب الكتب: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// إعادة تحميل الكتب
  Future<void> refreshBooks() async {
    await fetchBooks();
  }

  /// البحث في الكتب
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      return await BookService.searchBooks(query);
    } catch (e) {
      _setError('خطأ في البحث: $e');
      return [];
    }
  }

  /// جلب كتاب بالمعرف
  Future<BookModel?> getBookById(String bookId) async {
    try {
      return await BookService.fetchBookById(bookId);
    } catch (e) {
      _setError('خطأ في جلب الكتاب: $e');
      return null;
    }
  }

  /// تحديث حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// تعيين رسالة خطأ
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// مسح رسالة الخطأ
  void _clearError() {
    _errorMessage = null;
  }

  /// مسح جميع البيانات
  void clearData() {
    _booksByCategory = {
      'الروايات': [],
      'تطوير الذات': [],
      'علم النفس': [],
      'الكل': [],
    };
    _selectedCategory = 'الكل';
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
