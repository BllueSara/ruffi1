import '../models/user_model.dart';

class UserService {
  static UserModel? _currentUser;
  
  /// الحصول على المستخدم الحالي
  static UserModel? getCurrentUser() {
    return _currentUser;
  }

  /// تسجيل دخول المستخدم
  static Future<bool> login(String email, String password) async {
    try {
      // محاكاة تسجيل الدخول
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: '1',
        name: 'سارا',
        email: email,
        profileImage: 'images/PictProf.png',
        createdAt: DateTime.now(),
        lastLoginDate: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
      return false;
    }
  }

  /// تسجيل مستخدم جديد
  static Future<bool> register(String name, String email, String password) async {
    try {
      // محاكاة التسجيل
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
        lastLoginDate: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      print('خطأ في التسجيل: $e');
      return false;
    }
  }

  /// تسجيل خروج المستخدم
  static void logout() {
    _currentUser = null;
  }

  /// إضافة كتاب للمفضلة
  static Future<bool> addToFavorites(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      if (!_currentUser!.favoriteBooks.contains(bookId)) {
        _currentUser = _currentUser!.copyWith(
          favoriteBooks: [..._currentUser!.favoriteBooks, bookId]
        );
      }
      return true;
    } catch (e) {
      print('خطأ في إضافة المفضلة: $e');
      return false;
    }
  }

  /// إزالة كتاب من المفضلة
  static Future<bool> removeFromFavorites(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      _currentUser = _currentUser!.copyWith(
        favoriteBooks: _currentUser!.favoriteBooks.where((id) => id != bookId).toList()
      );
      return true;
    } catch (e) {
      print('خطأ في إزالة المفضلة: $e');
      return false;
    }
  }

  /// إضافة كتاب لتاريخ القراءة
  static Future<bool> addToReadingHistory(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      if (!_currentUser!.readingHistory.contains(bookId)) {
        _currentUser = _currentUser!.copyWith(
          readingHistory: [..._currentUser!.readingHistory, bookId]
        );
      }
      return true;
    } catch (e) {
      print('خطأ في إضافة تاريخ القراءة: $e');
      return false;
    }
  }

  /// التحقق من وجود المستخدم
  static bool isLoggedIn() {
    return _currentUser != null;
  }
}
