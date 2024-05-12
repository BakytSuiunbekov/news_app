import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/api/api_const.dart';
import 'package:news_app/components/custom_card.dart';
import 'package:news_app/models/top_headlines_model.dart';
import 'package:news_app/pages/home_detail_page.dart';
import 'package:news_app/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<TopHeadlinesModel?> fetchData() async {
    try {
      final dio = Dio();
      final response = await dio.get(ApiConst.api);
      if (response.statusCode == 200) {
        return TopHeadlinesModel.fromJson(response.data);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xfffe5722),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        title: const Text(
          'Акыркы маалыматтар',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    final news = snapshot.data!.articles[index];
                    return CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeDetailPage(articles: news),
                          ),
                        );
                      },
                      image: news.urlToImage,
                      author: news.author ?? '',
                      description: news.description ?? '',
                      time: DateFormat('d MMM, yyyy')
                          .format(DateTime.parse(news.publishedAt))
                          .toString(),
                    );
                  });
            } else {
              return const Center(child: Text('error'));
            }
          } else {
            return const Center(child: Text('error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xfffE5722),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchPage()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
