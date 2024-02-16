import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../RepeatedFunction/Drawer.dart';
import 'RepeatedFunction/repttext.dart';
import 'apikey/apikey.dart';
import 'details/checker.dart';
import 'repeatedfunction/searchbarfunc.dart';
import 'sectionPage/movies.dart';
import 'sectionPage/tvSeries.dart';
import 'sectionPage/upcomming.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trendingWeek = [];
  int uval = 1;
  Future<void> trendingList(int checkerNo) async {
    if (checkerNo == 1) {
      var trendingWeekUrl =
          'https://api.themoviedb.org/3/trending/all/week?api_key=$apikey';
      var trendingWeekResponse = await http.get(Uri.parse(trendingWeekUrl));
      if (trendingWeekResponse.statusCode == 200) {
        var tempData = jsonDecode(trendingWeekResponse.body);
        var trendingWeekJson = tempData['results'];
        for (var i = 0; i < trendingWeekJson.length; i++) {
          trendingWeek.add({
            'id': trendingWeekJson[i]['id'],
            'poster_path': trendingWeekJson[i]['poster_path'],
            'vote_average': trendingWeekJson[i]['vote_average'],
            'media_type': trendingWeekJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (checkerNo == 2) {
      var trendingWeekUrl =
          'https://api.themoviedb.org/3/trending/all/day?api_key=$apikey';
      var trendingWeekResponse = await http.get(Uri.parse(trendingWeekUrl));
      if (trendingWeekResponse.statusCode == 200) {
        var tempData = jsonDecode(trendingWeekResponse.body);
        var trendingWeekJson = tempData['results'];
        for (var i = 0; i < trendingWeekJson.length; i++) {
          trendingWeek.add({
            'id': trendingWeekJson[i]['id'],
            'poster_path': trendingWeekJson[i]['poster_path'],
            'vote_average': trendingWeekJson[i]['vote_average'],
            'media_type': trendingWeekJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    }
    // print(trendingWeek);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
        drawer: drawerfunc(),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 0.5),
        body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverAppBar(
              backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
              title: //switch between the trending this week and trending today
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Trending' ' 🔥',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16)),
                  const SizedBox(width: 10),
                  Container(
                    height: 45,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DropdownButton(
                        autofocus: true,
                        underline:
                        Container(height: 0, color: Colors.transparent),
                        dropdownColor: Colors.black.withOpacity(0.6),
                        icon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.amber,
                          size: 30,
                        ),
                        value: uval,
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              'Daily',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            trendingWeek.clear();
                            uval = int.parse(value.toString());
                            // trendingList(uval);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              // automaticallyImplyLeading: false,
              toolbarHeight: 60,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              actions: const [
                // IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: FutureBuilder(
                  future: trendingList(uval),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 2),
                            height: MediaQuery.of(context).size.height),
                        items: trendingWeek.map((i) {
                          return Builder(builder: (BuildContext context) {
                            return GestureDetector(
                                onTap: () {},
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DescriptionCheckUi(i['id'],
                                                      i['media_type'])));
                                    },
                                    child: Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          // color: Colors.amber,
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.3),
                                                    BlendMode.darken),
                                                image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500${i['poster_path']}'),
                                                fit: BoxFit.fill)),
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(
                                                          left: 10, bottom: 6),
                                                      child: Text(
                                                        ' # '
                                                            '${i['indexno'] + 1}',
                                                        style: TextStyle(
                                                            color: Colors.amber
                                                                .withOpacity(
                                                                0.7),
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets.only(
                                                            right: 8,
                                                            bottom: 5),
                                                        width: 90,
                                                        padding:
                                                        const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber
                                                                .withOpacity(
                                                                0.2),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .all(Radius
                                                                .circular(
                                                                8))),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              //rating icon
                                                              const Icon(Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 20),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                  '${i['vote_average']}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400))
                                                            ]))
                                                  ])
                                            ]))));
                          });
                        }).toList(),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ));
                    }
                  },
                ),
              )),
          //////////////////////////////////////////////End of Flexible bar///////////////////////////////////////////////////////////////
          SliverList(
              delegate: SliverChildListDelegate([
                const searchbarfun(),
                SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                        isScrollable: true,
                        controller: tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.amber.withOpacity(0.4)),
                        tabs: [
                          Tab(child: Tabbartext('Tv Series')),
                          Tab(child: Tabbartext('Movies')),
                          Tab(child: Tabbartext('Upcoming'))
                        ])),
                SizedBox(
                    height: 1100,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(controller: tabController, children: const [
                      TvSeries(),
                      Movie(),
                      Upcomming(),
                    ]))
              ]))
        ]));
  }
}