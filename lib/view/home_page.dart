import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../business_logic/model/article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> articles = <Article>[];

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future<void> getWebsiteData() async {
    final Uri url = Uri.parse('https://trangcongnghe.com.vn/');
    final http.Response response = await http.get(url);
    final dom.Document html = dom.Document.html(response.body);

    final List<String> titles = html
        .querySelectorAll('div.col-md-8 > div > h3 > a')
        .map((dom.Element element) => element.innerHtml.trim())
        .toList();

    final List<String> subTitles = html
        .querySelectorAll('div.col-md-8 > div > p')
        .map((dom.Element element) => element.innerHtml.trim())
        .toList();

    final List<String> urls = html
        .querySelectorAll('div.col-md-8 > div > h3 > a')
        .map((dom.Element element) => '${element.attributes['href']}')
        .toList();

    final List<String> imageUrls = html
        .querySelectorAll('div.col-md-4 > div > a > picture > img')
        .map((dom.Element element) => 'https:${element.attributes['data-src']}')
        .toList();

    setState(() {
      articles = List<Article>.generate(
        titles.length,
        (int index) => Article(
          url: urls[index],
          title: titles[index],
          imageUrl: imageUrls[index],
          subTitle: subTitles[index],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(articles[index].title),
            leading: CachedNetworkImage(
              imageUrl: articles[index].imageUrl,
              progressIndicatorBuilder: (
                BuildContext context,
                String url,
                DownloadProgress downloadProgress,
              ) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (BuildContext context, String url, Object error) =>
                  const Icon(Icons.error),
            ),
            subtitle: Text(articles[index].subTitle),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.amber);
        },
        itemCount: articles.length,
      ),
    );
  }
}
