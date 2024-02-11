import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> trendinglisthome() async{
    var trendingweekresponse = await http.get(Uri.parse(''));
    if (trendingweekresponse.statusCode == 200){
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingweekjson = tempdata['results'];
    }
  }
int uval = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trending'+'🔥',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width : 10),
              ],
            ),
          ),
            SliverList(delegate: SliverChildListDelegate([
            Center(
              child: Text('Simple text'),
            ),
          ],
          ),
          ),
        ],
      ),
    );
  }
}


// https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey'