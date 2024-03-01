import 'article.dart';

class ArticleDetail extends Article {
  ArticleDetail({
    required this.author,
    required this.contents,
    required super.url,
    required super.title,
    required super.imageUrl,
    required super.subTitle,
  });

  final String author;
  final List<String> contents;
}
