// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // لجعل خلفية الـAppBar شفافة
        elevation: 0, // إزالة تأثير الظل
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Image.asset('images/PictProf.png'),
              SizedBox(
                width: 16,
              ),
              IconButton(
                icon: Icon(Icons.menu, color: Colors.black), // أيقونة المينيو
                onPressed: () {
                  // الفعل عند الضغط على الأيقونة
                },
              ),
            ],
          ),
        ),
        leadingWidth: 200,
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            'صباح الخير سارا',
            style: TextStyle(
              fontSize: 16,

              fontFamily: 'IBMPlexSansArabic', // تحديد الفونت
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20,
            right: 16,
            left: 16), // إضافة مسافة من الأعلى واليمين واليسار
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // محاذاة العناصر في الوسط
          children: [
            SizedBox(height: 32), // مسافة بين النص والمربع
            Container(
              width: 384, // تحديد عرض المربع
              height: 186, // تحديد ارتفاع المربع
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xff816EF8),
                        Color(0xff4F3CC6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight) // زوايا دائرية
                  ),
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // توسيط النصوص عموديًا
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // توسيط النصوص أفقيًا
                  children: [
                    Text(
                      'اخترنا لك أفضل الكتب الموجودة حاليًا',
                      style: TextStyle(
                        color: Colors.white, // لون النص أبيض
                        fontSize: 20,

                        fontFamily: 'IBMPlexSansArabic', // تحديد الفونت
                      ),
                    ),
                    SizedBox(height: 8), // مسافة بين النصوص
                    Text(
                        'مجموعة من الكتب الممتعة التي تناسب جميع الأذواق. اطلع على التقييمات واكتشف الكتاب المناسب لذوقك الآن!',
                        style: TextStyle(
                          color: Colors.white70, // لون النص أبيض باهت
                          fontSize: 10,
                          fontFamily: 'IBMPlexSansArabic', // تحديد الفونت
                        ),
                        textAlign: TextAlign.center, // توسيط النص داخل المربع
                        textDirection: TextDirection.rtl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
