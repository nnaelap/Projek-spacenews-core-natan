import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_artikel.dart';

class DetailPage extends StatefulWidget {
  final ArticleModel article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;
  bool isLoadingFavorite = false;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  String get favoriteDocId {
    return '${uid}_${widget.article.id}';
  }

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(favoriteDocId)
        .get();

    if (!mounted) return;

    setState(() {
      isFavorite = doc.exists;
    });
  }

  Future<void> toggleFavorite() async {
    if (uid == null) {
      showMessage('User belum login');
      return;
    }

    try {
      setState(() => isLoadingFavorite = true);

      final favoriteRef = FirebaseFirestore.instance
          .collection('favorites')
          .doc(favoriteDocId);

      if (isFavorite) {
        await favoriteRef.delete();

        if (!mounted) return;

        setState(() => isFavorite = false);
        showMessage('Berita dihapus dari favorite');
      } else {
        await favoriteRef.set({
          ...widget.article.toFavoriteMap(uid!),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        setState(() => isFavorite = true);
        showMessage('Berita berhasil disimpan ke favorite');
      }
    } catch (e) {
      showMessage('Gagal menyimpan favorite: $e');
    } finally {
      if (mounted) setState(() => isLoadingFavorite = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Article'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: isLoadingFavorite ? null : toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              article.imageUrl,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 280,
                  color: Colors.white12,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 70,
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  infoText('Media Penerbit', article.newsSite),

                  const SizedBox(height: 8),

                  infoText('Published At', article.publishedAt),

                  const SizedBox(height: 24),

                  const Text(
                    'Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    article.summary,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 16,
                    ),
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
