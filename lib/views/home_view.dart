import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';
import '../widgets/category_tab.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_state_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // جلب الكتب عند بدء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<HomeController>(
        builder: (context, homeController, child) {
          if (homeController.isLoading && homeController.currentBooks.isEmpty) {
            return const LoadingWidget(message: 'جاري تحميل الكتب...');
          }

          if (homeController.errorMessage != null) {
            return CustomErrorWidget(
              message: homeController.errorMessage!,
              onRetry: () => homeController.fetchBooks(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => homeController.refreshBooks(),
            child: Column(
              children: [
                _buildCategoryTabs(homeController),
                Expanded(
                  child: _buildBooksGrid(homeController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('images/PictProf.png'),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      leadingWidth: 200,
      title: Consumer<AuthController>(
        builder: (context, authController, child) {
          final userName = authController.currentUser?.name ?? 'سارا';
          return Align(
            alignment: Alignment.topRight,
            child: Text(
              'صباح الخير $userName',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildCategoryTabs(HomeController homeController) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeController.categories.length,
        itemBuilder: (context, index) {
          final category = homeController.categories[index];
          final isSelected = homeController.selectedCategory == category.displayName;
          
          return CategoryTab(
            category: category,
            isSelected: isSelected,
            onTap: () => homeController.selectCategory(category.displayName),
          );
        },
      ),
    );
  }

  Widget _buildBooksGrid(HomeController homeController) {
    final books = homeController.currentBooks;
    
    if (books.isEmpty) {
      return const EmptyStateWidget(
        title: 'لا توجد كتب في هذا التصنيف',
        subtitle: 'جرب تصنيف آخر أو انتظر قليلاً',
        icon: Icons.book_outlined,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          book: book,
          onTap: () {
            // TODO: الانتقال إلى صفحة تفاصيل الكتاب
          },
        );
      },
    );
  }
}
