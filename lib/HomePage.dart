import 'dart:convert';

import 'package:cine_pick/apilinks/alllinks.dart';
import 'package:cine_pick/sectionPage/movies.dart';
import 'package:cine_pick/sectionPage/tvSeries.dart';
import 'package:cine_pick/sectionPage/upcomming.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> trendinglisthome() async {
    if (uval == 1) {
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendinglist.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (uval == 2) {
      var trendingdayresponse = await http.get(Uri.parse(trendingdayurl));
      if (trendingdayresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingdayresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendinglist.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else {}
  }

  int uval = 1;

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            // automaticallyImplyLeading: false,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                  future: trendinglisthome(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 2),
                            height: MediaQuery.of(context).size.height),
                        items: trendinglist.map((i) {
                          return Builder(builder: (BuildContextcontest) {
                            return GestureDetector(
                              onTap: () {},
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      //color: Colors.amber,
                                      image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.3),
                                        BlendMode.darken),
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${i['poster_path']}',
                                    ),
                                    fit: BoxFit.fill,
                                  )),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                  }),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trending' + '🔥',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      onChanged: (value) {
                        setState(() {
                          trendinglist.clear();
                          uval = int.parse(value.toString());
                        });
                      },
                      autofocus: true,
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      dropdownColor: Colors.black.withOpacity(0.6),
                      icon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.amber,
                        size: 30,
                      ),
                      value: uval,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          value: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Text('Simple text'),
                ),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber.withOpacity(0.4)),
                    tabs: [
                      Tab(
                        child: Text('Tv Series'),
                      ),
                      Tab(
                        child: Text('Movies'),
                      ),
                      Tab(
                        child: Text('Upcoming'),
                      )
                    ],
                  ),
                ),
                Container(
                    height: 1100,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(controller: _tabController, children: const [
                      TvSeries(),
                      Movie(),
                      Upcomming(),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey'
