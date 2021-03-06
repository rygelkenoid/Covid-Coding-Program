import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:update_me/models/post.dart';
import 'dart:async';
import 'dart:convert';

import 'package:update_me/widgets/news_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url =
      "http://newsapi.org/v2/top-headlines?apiKey=33b24be8d9404eef8fed1bee30c73f2f&country=in";
  bool isLoaded = false;

  List<Post> posts = List();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(this.url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        posts = (data["articles"] as List).map((post) {
          return Post.fromJSON(post);
        }).toList();
        setState(() {
          this.isLoaded = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Update Me",
            style: TextStyle(color: Colors.black, fontSize: 26, fontFamily: 'Baloo'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          child: isLoaded
              ? ListView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return NewsCard(posts[index]);
                  },
                )
              : Center(child: CircularProgressIndicator()),
          onRefresh: _fetchData,
        ));
  }
}
