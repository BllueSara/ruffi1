import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/book_card.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  List<BookModel> _favoriteBooks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الكتب المفضلة',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          if (authController.currentUser == null) {
            return const Center(
              child: Text(
                'يرجى تسجيل الدخول أولاً',
                style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
              ),
            );
          }

          if (_isLoading) {
            return const LoadingWidget(message: 'جاري تحميل الكتب المفضلة...');
          }

          if (_favoriteBooks.isEmpty) {
            return const EmptyStateWidget(
              title: 'لا توجد كتب مفضلة',
              subtitle: 'ابدأ بإضافة كتبك المفضلة من الشاشة الرئيسية',
              icon: Icons.favorite_border,
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavoriteBooks,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = _favoriteBooks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BookCard(
                    book: book,
                    onTap: () {
                      // TODO: الانتقال إلى صفحة تفاصيل الكتاب
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }


  Future<void> _loadFavoriteBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authController = context.read<AuthController>();
      final favoriteIds = authController.currentUser?.favoriteBooks ?? [];
      
      final books = <BookModel>[];
      for (final id in favoriteIds) {
        final book = await BookService.fetchBookById(id);
        if (book != null) {
          books.add(book);
        }
      }

      setState(() {
        _favoriteBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // يمكن إضافة رسالة خطأ هنا
    }
  }
}
