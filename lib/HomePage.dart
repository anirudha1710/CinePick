import 'dart:convert';

import 'package:cine_pick/apilinks/alllinks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>> trendinglist = [];
  Future<void> trendinglisthome() async{
    var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
    if (trendingweekresponse.statusCode == 200){
      var tempdata = jsonDecode(trendingweekresponse.body);
      var trendingweekjson = tempdata['results'];
      for (var i = 0; i< trendingweekjson.length; i++){
        trendinglist.add({
          'id' : trendingweekjson[i]['id'],
          'poster_path' : trendingweekjson[i]['poster_path'],
          'vote_average' : trendingweekjson[i]['vote_average'],
          'media_type' : trendingweekjson[i]['media_type'],
          'indexno' : i,
        });
      }
    }
  }
int uval = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
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