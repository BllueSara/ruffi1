import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/book_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<BookModel> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              controller: _searchController,
              labelText: 'البحث عن كتاب',
              hintText: 'ابحث عن كتاب...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults.clear();
                          _errorMessage = null;
                        });
                      },
                    )
                  : null,
              onSubmitted: (value) => _performSearch(value),
              onChanged: (value) {
                setState(() {});
                if (value.isEmpty) {
                  setState(() {
                    _searchResults.clear();
                    _errorMessage = null;
                  });
                }
              },
            ),
          ),

          // نتائج البحث
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const LoadingWidget(message: 'جاري البحث...');
    }

    if (_errorMessage != null) {
      return CustomErrorWidget(
        message: _errorMessage!,
        onRetry: () => _performSearch(_searchController.text),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const EmptyStateWidget(
        title: 'لا توجد نتائج للبحث',
        subtitle: 'جرب كلمات بحث مختلفة',
        icon: Icons.search_off,
      );
    }

    if (_searchResults.isEmpty) {
      return const EmptyStateWidget(
        title: 'ابدأ بالبحث عن الكتب',
        subtitle: 'اكتب اسم الكتاب أو المؤلف',
        icon: Icons.search,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final book = _searchResults[index];
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
    );
  }


  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final results = await BookService.searchBooks(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في البحث: $e';
        _isSearching = false;
      });
    }
  }
}
