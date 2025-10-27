import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// تسجيل الدخول
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await UserService.login(email, password);
      if (success) {
        _currentUser = UserService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('فشل في تسجيل الدخول');
        return false;
      }
    } catch (e) {
      _setError('خطأ في تسجيل الدخول: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// تسجيل مستخدم جديد
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await UserService.register(name, email, password);
      if (success) {
        _currentUser = UserService.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('فشل في التسجيل');
        return false;
      }
    } catch (e) {
      _setError('خطأ في التسجيل: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// تسجيل الخروج
  void logout() {
    UserService.logout();
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  /// إضافة كتاب للمفضلة
  Future<bool> addToFavorites(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      final success = await UserService.addToFavorites(bookId);
      if (success) {
        _currentUser = UserService.getCurrentUser();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('خطأ في إضافة المفضلة: $e');
      return false;
    }
  }

  /// إزالة كتاب من المفضلة
  Future<bool> removeFromFavorites(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      final success = await UserService.removeFromFavorites(bookId);
      if (success) {
        _currentUser = UserService.getCurrentUser();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('خطأ في إزالة المفضلة: $e');
      return false;
    }
  }

  /// التحقق من وجود كتاب في المفضلة
  bool isFavorite(String bookId) {
    return _currentUser?.favoriteBooks.contains(bookId) ?? false;
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

  @override
  void dispose() {
    super.dispose();
  }
}
