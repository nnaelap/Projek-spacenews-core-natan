import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Breaking Space News',
      'time': 'Just now',
      'message': 'Artikel terbaru tentang misi luar angkasa telah tersedia.',
    },
    {
      'title': 'Favorite Updated',
      'time': '5 minutes ago',
      'message': 'Daftar favorite Anda telah diperbarui secara real-time.',
    },
    {
      'title': 'Daily Space Feed',
      'time': 'Today',
      'message': 'Baca kumpulan berita antariksa terbaru hari ini.',
    },
    {
      'title': 'Profile Sync',
      'time': 'Yesterday',
      'message': 'Data profil pengguna berhasil disinkronkan dari Firestore.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];

        return Card(
          color: const Color(0xff111936),
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
            title: Text(
              item['title']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              item['message']!,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Text(
              item['time']!,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}