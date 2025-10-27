import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          final user = authController.currentUser;
          
          if (user == null) {
            return const Center(
              child: Text(
                'يرجى تسجيل الدخول أولاً',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // صورة الملف الشخصي
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.profileImage != null
                      ? AssetImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                const SizedBox(height: 20),
                
                // معلومات المستخدم
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'IBMPlexSansArabic',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // إحصائيات
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'الكتب المفضلة',
                        user.favoriteBooks.length.toString(),
                        Icons.favorite,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'تاريخ القراءة',
                        user.readingHistory.length.toString(),
                        Icons.history,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // قائمة الإعدادات
                _buildSettingsList(authController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'IBMPlexSansArabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(AuthController authController) {
    return Column(
      children: [
        _buildSettingsItem(
          icon: Icons.edit,
          title: 'تعديل الملف الشخصي',
          onTap: () {
            // TODO: تنفيذ تعديل الملف الشخصي
          },
        ),
        _buildSettingsItem(
          icon: Icons.notifications,
          title: 'الإشعارات',
          onTap: () {
            // TODO: الانتقال إلى صفحة الإشعارات
          },
        ),
        _buildSettingsItem(
          icon: Icons.help,
          title: 'المساعدة والدعم',
          onTap: () {
            // TODO: الانتقال إلى صفحة المساعدة
          },
        ),
        _buildSettingsItem(
          icon: Icons.info,
          title: 'حول التطبيق',
          onTap: () {
            // TODO: عرض معلومات التطبيق
          },
        ),
        _buildSettingsItem(
          icon: Icons.logout,
          title: 'تسجيل الخروج',
          onTap: () {
            _showLogoutDialog(authController);
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'IBMPlexSansArabic',
            color: isDestructive ? Colors.red : null,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(AuthController authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'IBMPlexSansArabic'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              authController.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
