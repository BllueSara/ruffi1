import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'الكل'; // التصنيف الافتراضي
  Map<String, List<dynamic>> booksByCategory = {
    'الروايات': [],
    'تطوير الذات': [],
    'علم النفس': [],
    'الكل': [],
  };

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    // تصنيفات الكتب وكلمات البحث لكل تصنيف
    final categories = {
      'الكل': [
        'فن اللامبالاة',
        'ثلاثية غرناطة',
        'العادات الذرية',
        'ابي الذي اكره',
        'عقدك النفسية سجنك الأبدي',
        'الطنطورية'
      ],
      'الروايات': ['ثلاثية غرناطة', 'الطنطورية'],
      'تطوير الذات': ['فن اللامبالاة', 'العادات الذرية'],
      'علم النفس': ['ابي الذي اكره', 'عقدك النفسية سجنك الأبدي'],
    };

    // جلب النتائج
    for (var category in categories.keys) {
      final queryList = categories[category]!;
      final responses = await Future.wait(queryList.map((query) async {
        final url = 'https://www.googleapis.com/books/v1/volumes?q=$query';
        return await http.get(Uri.parse(url));
      }));

      List<dynamic> fetchedBooks = [];
      for (var response in responses) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['items'] != null && data['items'].isNotEmpty) {
            fetchedBooks.add(data['items'][0]);
          }
        }
      }

      setState(() {
        booksByCategory[category] = fetchedBooks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            'صباح الخير سارا',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'IBMPlexSansArabic',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 32),
            _buildTopHighlight(),
            const SizedBox(height: 24),
            _buildCategoryTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBooksList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHighlight() {
    return Container(
      width: double.infinity,
      height: 186,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xff816EF8),
            Color(0xff4F3CC6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'اخترنا لك أفضل الكتب الموجودة حاليًا',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'مجموعة من الكتب الممتعة التي تناسب جميع الأذواق. اطلع على التقييمات واكتشف الكتاب المناسب لذوقك الآن!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontFamily: 'IBMPlexSansArabic',
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: booksByCategory.keys.map((category) {
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xff816EF8) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff816EF8)
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBooksList() {
    final books = booksByCategory[selectedCategory] ?? [];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الكتب في كل صف
        mainAxisSpacing: 8.0, // المسافة العمودية بين الصفوف
        crossAxisSpacing: 8.0, // المسافة الأفقية بين العناصر
        childAspectRatio: 2 / 3, // نسبة العرض إلى الطول
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _buildCategorySection(selectedCategory, [books[index]]);
      },
      shrinkWrap: true, // إذا كان داخل قائمة
    );
  }

  Widget _buildCategorySection(String category, List<dynamic> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 250, // ارتفاع الكارد
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // تمرير أفقي
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final volumeInfo = book['volumeInfo'];
              return _buildBookCard(volumeInfo);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(Map<String, dynamic> volumeInfo) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 140, // عرض الكارد
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(volumeInfo['imageLinks']
                            ?['thumbnail'] ??
                        'https://via.placeholder.com/128x192.png?text=No+Image'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    volumeInfo['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    volumeInfo['authors']?.join(', ') ?? 'No Author',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
