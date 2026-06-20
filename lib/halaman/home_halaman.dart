import 'package:flutter/material.dart';

import '../models/model_artikel.dart';
import '../layanan/layanan_artikel.dart';
import '../widgets/kartu_berita.dart';
import 'detail_halaman.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ArticleService articleService = ArticleService();

  late Future<List<ArticleModel>> articlesFuture;

  @override
  void initState() {
    super.initState();
    articlesFuture = articleService.fetchArticles();
  }

  Future<void> refreshArticles() async {
    setState(() {
      articlesFuture = articleService.fetchArticles();
    });
  }

  void openDetail(ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada berita',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final headline = articles.first;
        final otherArticles = articles.skip(1).toList();

        return RefreshIndicator(
          onRefresh: refreshArticles,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Headline News',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () => openDetail(headline),
                  child: Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white12,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            headline.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white12,
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.75),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  headline.newsSite,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  headline.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Latest Articles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherArticles.length,
                  itemBuilder: (context, index) {
                    final article = otherArticles[index];

                    return NewsCard(
                      article: article,
                      onTap: () => openDetail(article),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
