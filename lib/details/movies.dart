import 'dart:convert';
import 'package:cine_pick/HomePage.dart';
import 'package:cine_pick/RepeatedFunction/repttext.dart';
import 'package:cine_pick/apikey/apikey.dart';
import 'package:cine_pick/repeatedfunction/favouriteAndShare.dart';
import 'package:cine_pick/repeatedfunction/reviewUi.dart';
import 'package:cine_pick/repeatedfunction/slider.dart';
import 'package:cine_pick/repeatedfunction/trailerUI.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class MovieDetails extends StatefulWidget {
  var id;

  MovieDetails({super.key, this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> movieDetails = [];
  List<Map<String, dynamic>> userReviews = [];
  List<Map<String, dynamic>> similarMoviesList = [];
  List<Map<String, dynamic>> recommendedMoviesList = [];
  List<Map<String, dynamic>> movieTrailerList = [];

  List moviesGenres = [];

  Future MovieDetails() async {
    var movieDetailUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=$apikey';
    var userReviewUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}/reviews?api_key=$apikey';
    var similarMoviesUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}/similar?api_key=$apikey';
    var recommendedMoviesUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}/recommendations?api_key=$apikey';
    var movieTrailersUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}/videos?api_key=$apikey';

    var movieDetailResponse = await http.get(Uri.parse(movieDetailUrl));
    if (movieDetailResponse.statusCode == 200) {
      var movieDetailJson = jsonDecode(movieDetailResponse.body);
      for (var i = 0; i < 1; i++) {
        movieDetails.add({
          "backdrop_path": movieDetailJson['backdrop_path'],
          "title": movieDetailJson['title'],
          "vote_average": movieDetailJson['vote_average'],
          "overview": movieDetailJson['overview'],
          "release_date": movieDetailJson['release_date'],
          "runtime": movieDetailJson['runtime'],
          "budget": movieDetailJson['budget'],
          "revenue": movieDetailJson['revenue'],
        });
      }
      for (var i = 0; i < movieDetailJson['genres'].length; i++) {
        moviesGenres.add(movieDetailJson['genres'][i]['name']);
      }
    } else {}

    /////////////////////////////User Reviews///////////////////////////////
    var userReviewResponse = await http.get(Uri.parse(userReviewUrl));
    if (userReviewResponse.statusCode == 200) {
      var userReviewJson = jsonDecode(userReviewResponse.body);
      for (var i = 0; i < userReviewJson['results'].length; i++) {
        userReviews.add(
          {
            "name": userReviewJson['results'][i]['author'],
            "review": userReviewJson['results'][i]['content'],
            //check rating is null or not
            "rating":
                userReviewJson['results'][i]['author_details']['rating'] == null
                    ? "Not Rated"
                    : userReviewJson['results'][i]['author_details']['rating']
                        .toString(),
            "avatarPhoto": userReviewJson['results'][i]['author_details']
                        ['avatar_path'] ==
                    null
                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                : "https://image.tmdb.org/t/p/w500" +
                    userReviewJson['results'][i]['author_details']
                        ['avatar_path'],
            "creationdate":
                userReviewJson['results'][i]['created_at'].substring(0, 10),
            "fullReviewUrl": userReviewJson['results'][i]['url'],
          },
        );
      }
    } else {}
    /////////////////////////////similar movies
    var similarMoviesResponse = await http.get(Uri.parse(similarMoviesUrl));
    if (similarMoviesResponse.statusCode == 200) {
      var similarMoviesJson = jsonDecode(similarMoviesResponse.body);
      for (var i = 0; i < similarMoviesJson['results'].length; i++) {
        similarMoviesList.add(
          {
            "poster_path": similarMoviesJson['results'][i]['poster_path'],
            "name": similarMoviesJson['results'][i]['title'],
            "vote_average": similarMoviesJson['results'][i]['vote_average'],
            "Date": similarMoviesJson['results'][i]['release_date'],
            "id": similarMoviesJson['results'][i]['id'],
          },
        );
      }
    } else {}

    var recommendedMoviesResponse =
        await http.get(Uri.parse(recommendedMoviesUrl));
    if (recommendedMoviesResponse.statusCode == 200) {
      var recommendedMoviesJson = jsonDecode(recommendedMoviesResponse.body);
      for (var i = 0; i < recommendedMoviesJson['results'].length; i++) {
        recommendedMoviesList.add(
          {
            "poster_path": recommendedMoviesJson['results'][i]['poster_path'],
            "name": recommendedMoviesJson['results'][i]['title'],
            "vote_average": recommendedMoviesJson['results'][i]['vote_average'],
            "Date": recommendedMoviesJson['results'][i]['release_date'],
            "id": recommendedMoviesJson['results'][i]['id'],
          },
        );
      }
    } else {}
    // print(recommendedMoviesList);
    /////movie trailers
    var movieTrailersResponse = await http.get(Uri.parse(movieTrailersUrl));
    if (movieTrailersResponse.statusCode == 200) {
      var movieTrailersJson = jsonDecode(movieTrailersResponse.body);
      for (var i = 0; i < movieTrailersJson['results'].length; i++) {
        if (movieTrailersJson['results'][i]['type'] == "Trailer") {
          movieTrailerList.add(
            {
              "key": movieTrailersJson['results'][i]['key'],
            },
          );
        }
      }
      movieTrailerList.add({'key': 'aJ0cZTcTh90'});
    } else {}
    // print(movieTrailerList);
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
        future: MovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        onPressed: () {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: [SystemUiOverlay.bottom]);
                          // SystemChrome.setEnabledSystemUIMode(
                          //     SystemUiMode.manual,
                          //     overlays: []);
                          SystemChrome.setPreferredOrientations(
                            [
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ],
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(FontAwesomeIcons.circleArrowLeft),
                        iconSize: 28,
                        color: Colors.white),
                    actions: [
                      IconButton(
                          onPressed: () {
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
                    centerTitle: false,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: trailerwatch(
                          trailerytid: movieTrailerList[0]['key'],
                        ),
                      ),
                      // background: FittedBox(
                      //   fit: BoxFit.fill,
                      //   child: Container(
                      //     child: trailer watch(
                      //       trailered: movie trailers list[0]['key'],
                      //     ),
                      //   ),
                      // ),
                    )),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      //add to favourite button
                      addtofavoriate(
                        id: widget.id,
                        type: 'movie',
                        Details: movieDetails,
                      ),

                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: moviesGenres.length,
                                  itemBuilder: (context, index) {
                                    //genres box
                                    return Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                25, 25, 25, 1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: genrestext(moviesGenres[index]));
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(25, 25, 25, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: genrestext(
                                      '${movieDetails[0]['runtime']} min'))
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: tittletext('Movie Story :')),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: overviewtext(
                              movieDetails[0]['overview'].toString())),

                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: ReviewUI(revdeatils: userReviews),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Release Date : ${movieDetails[0]['release_date']}')),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Budget : ${movieDetails[0]['budget']}')),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Revenue : ${movieDetails[0]['revenue']}')),
                      sliderlist(similarMoviesList, "Similar Movies", "movie",
                          similarMoviesList.length),
                      sliderlist(recommendedMoviesList, "Recommended Movies",
                          "movie", recommendedMoviesList.length),
                      // Container(
                      //     height: 50,
                      //     child: Center(child: normalText))
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          }
        },
      ),
    );
  }
}
