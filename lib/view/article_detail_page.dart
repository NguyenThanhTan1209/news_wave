import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../business_logic/model/article.dart';
import '../business_logic/model/article_detail.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.article});

  final Article article;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  ArticleDetail? _articleDetail;

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future<void> getWebsiteData() async {
    try {
      final Uri url = Uri.parse('https://genk.vn${widget.article.url}');
    final http.Response response = await http.get(url);
    final dom.Document html = dom.Document.html(response.body);

    final String author = html
        .querySelector('div.kbwc-header.clearfix > div.kbwc-meta > span.kbwcm-author')!
        .innerHtml
        .split(',')
        .first
        .trim();

    final List<String> contents = html
        .querySelectorAll(
          '#ContentDetail > p',
        )
        .map((dom.Element element) => element.innerHtml.trim())
        .toList();

    setState(() {
      _articleDetail = ArticleDetail(
        author: author,
        contents: contents,
        url: widget.article.url,
        title: widget.article.title,
        imageUrl: widget.article.imageUrl,
        subTitle: widget.article.subTitle,
      );
    });
    } catch (e) {
      print(e);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  _articleDetail?.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _articleDetail?.author ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.contain,
                  imageUrl: _articleDetail?.imageUrl ?? '',
                  progressIndicatorBuilder: (
                    BuildContext context,
                    String url,
                    DownloadProgress downloadProgress,
                  ) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (BuildContext context, String url, Object error) =>
                      const Icon(Icons.error),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      Text(_articleDetail?.contents[index] ?? ''),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16,),
                  itemCount: _articleDetail?.contents.length ?? 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
