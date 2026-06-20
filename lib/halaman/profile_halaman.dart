import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'daftar_halaman.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
      (route) => false,
    );
  }

  Widget profileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      color: const Color(0xff111936),
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white54),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(
        child: Text(
          'User belum login',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
              'Data profil tidak ditemukan',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final name = data['name'] ?? '-';
        final email = data['email'] ?? '-';
        final instagram = data['instagram'] ?? '-';
        final photoUrl = data['photoUrl'] ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurple,
                backgroundImage:
                    photoUrl.toString().isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.toString().isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 70,
                      )
                    : null,
              ),

              const SizedBox(height: 24),

              profileItem(
                icon: Icons.person,
                label: 'Nama Lengkap',
                value: name,
              ),

              profileItem(
                icon: Icons.email,
                label: 'Email',
                value: email,
              ),

              profileItem(
                icon: Icons.camera_alt,
                label: 'Akun Instagram',
                value: instagram,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}