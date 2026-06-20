import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/model_artikel.dart';

class ArticleService {
  static const String apiUrl =
      'https://api.spaceflightnewsapi.net/v4/articles/?limit=20';

  Future<List<ArticleModel>> fetchArticles() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'] ?? [];

      return results
          .map((item) => ArticleModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal memuat berita. Status: ${response.statusCode}');
    }
  }
}