class ArticleModel {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? '-',
      summary: json['summary'] ?? '-',
      publishedAt: json['published_at'] ?? '',
    );
  }

  factory ArticleModel.fromFavorite(Map<String, dynamic> data) {
    return ArticleModel(
      id: data['articleId'] is int
          ? data['articleId']
          : int.tryParse(data['articleId'].toString()) ?? 0,
      title: data['title'] ?? '-',
      url: data['url'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      newsSite: data['newsSite'] ?? '-',
      summary: data['summary'] ?? '-',
      publishedAt: data['publishedAt'] ?? '',
    );
  }

  Map<String, dynamic> toFavoriteMap(String userId) {
    return {
      'userId': userId,
      'articleId': id,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'newsSite': newsSite,
      'summary': summary,
      'publishedAt': publishedAt,
    };
  }
}