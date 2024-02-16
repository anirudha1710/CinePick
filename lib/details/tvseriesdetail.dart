import 'dart:convert';
import 'package:cine_pick/HomePage.dart';
import 'package:cine_pick/apikey/apikey.dart';
import 'package:cine_pick/repeatedfunction/favouriteAndShare.dart';
import 'package:cine_pick/repeatedfunction/repttext.dart';
import 'package:cine_pick/repeatedfunction/reviewUi.dart';
import 'package:cine_pick/repeatedfunction/slider.dart';
import 'package:cine_pick/repeatedfunction/trailerUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class tvSeriesDetail extends StatefulWidget {
  final id;

  const tvSeriesDetail({super.key, this.id});

  @override
  State<tvSeriesDetail> createState() => _tvSeriesDetailState();
}

class _tvSeriesDetailState extends State<tvSeriesDetail> {
  var tvSeriesDetailData;
  List<Map<String, dynamic>> tvSeriesDetails = [];
  List<Map<String, dynamic>> tvSeriesReview = [];
  List<Map<String, dynamic>> similarSeriesList = [];
  List<Map<String, dynamic>> recommendSeriesList = [];
  List<Map<String, dynamic>> seriesTrailersList = [];

  Future<void> tvSeriesDetailFunction() async {
    var tvSeriesDetailUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}?api_key=$apikey';
    var tvSeriesReviewUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/reviews?api_key=$apikey';
    var similarSeriesUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/similar?api_key=$apikey';
    var recommendSeriesUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/recommendations?api_key=$apikey';
    var seriesTrailersUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/videos?api_key=$apikey';
    // 'https://api.themoviedb.org/3/tv/' +
    //     widget.id.toString() +
    //     '/videos?api_key=$apikey';

    var tvSeriesDetailResponse = await http.get(Uri.parse(tvSeriesDetailUrl));
    if (tvSeriesDetailResponse.statusCode == 200) {
      tvSeriesDetailData = jsonDecode(tvSeriesDetailResponse.body);
      for (var i = 0; i < 1; i++) {
        tvSeriesDetails.add(
          {
            'backdrop_path': tvSeriesDetailData['backdrop_path'],
            'title': tvSeriesDetailData['original_name'],
            'vote_average': tvSeriesDetailData['vote_average'],
            'overview': tvSeriesDetailData['overview'],
            'status': tvSeriesDetailData['status'],
            'releaseDate': tvSeriesDetailData['first_air_date'],
          },
        );
      }
      for (var i = 0; i < tvSeriesDetailData['genres'].length; i++) {
        tvSeriesDetails.add(
          {
            'genre': tvSeriesDetailData['genres'][i]['name'],
          },
        );
      }
      for (var i = 0; i < tvSeriesDetailData['created_by'].length; i++) {
        tvSeriesDetails.add(
          {
            'creator': tvSeriesDetailData['created_by'][i]['name'],
            'creatorProfile': tvSeriesDetailData['created_by'][i]
                ['profile_path'],
          },
        );
      }
      for (var i = 0; i < tvSeriesDetailData['seasons'].length; i++) {
        tvSeriesDetails.add(
          {
            'season': tvSeriesDetailData['seasons'][i]['name'],
            'episode_count': tvSeriesDetailData['seasons'][i]['episode_count'],
          },
        );
      }
    } else {}
    //tv Series review//

    var tvSeriesReviewResponse = await http.get(Uri.parse(tvSeriesReviewUrl));
    if (tvSeriesReviewResponse.statusCode == 200) {
      var tvSeriesReviewData = jsonDecode(tvSeriesReviewResponse.body);
      for (var i = 0; i < tvSeriesReviewData['results'].length; i++) {
        tvSeriesReview.add(
          {
            'name': tvSeriesReviewData['results'][i]['author'],
            'review': tvSeriesReviewData['results'][i]['content'],
            "rating": tvSeriesReviewData['results'][i]['author_details']
                        ['rating'] ==
                    null
                ? "Not Rated"
                : tvSeriesReviewData['results'][i]['author_details']['rating']
                    .toString(),
            "avatarPhoto": tvSeriesReviewData['results'][i]['author_details']
                        ['avatar_path'] ==
                    null
                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                : "https://image.tmdb.org/t/p/w500" +
                    tvSeriesReviewData['results'][i]['author_details']
                        ['avatar_path'],
            "creationDate":
                tvSeriesReviewData['results'][i]['created_at'].substring(0, 10),
            "fullReviewUrl": tvSeriesReviewData['results'][i]['url'],
          },
        );
      }
    } else {}
    //similar series

    var similarSeriesResponse = await http.get(Uri.parse(similarSeriesUrl));
    if (similarSeriesResponse.statusCode == 200) {
      var similarSeriesData = jsonDecode(similarSeriesResponse.body);
      for (var i = 0; i < similarSeriesData['results'].length; i++) {
        similarSeriesList.add(
          {
            'poster_path': similarSeriesData['results'][i]['poster_path'],
            'name': similarSeriesData['results'][i]['original_name'],
            'vote_average': similarSeriesData['results'][i]['vote_average'],
            'id': similarSeriesData['results'][i]['id'],
            'Date': similarSeriesData['results'][i]['first_air_date'],
          },
        );
      }
    } else {}
    //recommend series

    var recommendSeriesResponse = await http.get(Uri.parse(recommendSeriesUrl));
    if (recommendSeriesResponse.statusCode == 200) {
      var recommendSeriesData = jsonDecode(recommendSeriesResponse.body);
      for (var i = 0; i < recommendSeriesData['results'].length; i++) {
        recommendSeriesList.add(
          {
            'poster_path': recommendSeriesData['results'][i]['poster_path'],
            'name': recommendSeriesData['results'][i]['original_name'],
            'vote_average': recommendSeriesData['results'][i]['vote_average'],
            'id': recommendSeriesData['results'][i]['id'],
            'Date': recommendSeriesData['results'][i]['first_air_date'],
          },
        );
      }
    } else {}

    //tv series trailer//
    var tvSeriesTrailerResponse = await http.get(Uri.parse(seriesTrailersUrl));
    if (tvSeriesTrailerResponse.statusCode == 200) {
      var tvseriestrailerdata = jsonDecode(tvSeriesTrailerResponse.body);
      // print(tvseriestrailerdata);
      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        //add only if type is trailer
        if (tvseriestrailerdata['results'][i]['type'] == "Trailer") {
          seriesTrailersList.add(
            {
              'key': tvseriestrailerdata['results'][i]['key'],
            },
          );
        }
      }
      seriesTrailersList.add({'key': 'aJ0cZTcTh90'});
    } else {}
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: tvSeriesDetailFunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading:
                      //circular icon button
                      IconButton(
                          onPressed: () {
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.manual,
                                overlays: [SystemUiOverlay.bottom]);
                            // SystemChrome.setEnabledSystemUIMode(
                            //     SystemUiMode.manual,
                            //     overlays: []);
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            Navigator.pop(context);
                          },
                          icon: const Icon(FontAwesomeIcons.circleArrowLeft),
                          iconSize: 28,
                          color: Colors.white),
                  actions: [
                    IconButton(
                        onPressed: () {
                          //kill all previous routes and go to home page
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                        icon: const Icon(FontAwesomeIcons.houseUser),
                        iconSize: 25,
                        color: Colors.white)
                  ],
                  backgroundColor: const Color.fromRGBO(18, 18, 18, 0.5),
                  expandedHeight: MediaQuery.of(context).size.height * 0.35,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FittedBox(
                      fit: BoxFit.fill,
                      child: trailerwatch(
                        trailerytid: seriesTrailersList[0]['key'],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      addToFavourite(
                        id: widget.id,
                        type: 'tv',
                        Details: tvSeriesDetails,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: tvSeriesDetailData['genres']!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(25, 25, 25, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: genresText(tvSeriesDetails[index + 1]
                                            ['genre']
                                        .toString()));
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 12),
                          child: tittleText("Series Overview : ")),

                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: overviewtext(
                              tvSeriesDetails[0]['overview'].toString())),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: reviewUi(revDetails: tvSeriesReview),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: boldText(
                              "Status : ${tvSeriesDetails[0]['status']}")),
                      //created by
                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: tittleText("Created By : ")),
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: tvSeriesDetailData['created_by']!.length,
                          itemBuilder: (context, index) {
                            //genres box
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 45,
                                          backgroundImage: NetworkImage(
                                              'https://image.tmdb.org/t/p/w500${tvSeriesDetails[index + 4]['creatorProfile']}')),
                                      const SizedBox(height: 10),
                                      genresText(tvSeriesDetails[index + 4]
                                              ['creator']
                                          .toString())
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: normaltext(
                              "Total Seasons : ${tvSeriesDetailData['seasons'].length}")),

                      Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: normaltext(
                              "Release date : ${tvSeriesDetails[0]['releaseDate']}")),
                      sliderList(similarSeriesList, 'Similar Series', 'tv',
                          similarSeriesList.length),
                      sliderList(recommendSeriesList, 'Recommended Series',
                          'tv', recommendSeriesList.length),
                      Container(
                          //     height: 50,
                          //     child: Center(child: normalText)
                          ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(color: Colors.amber.shade400));
          }
        },
      ),
    );
  }
}
