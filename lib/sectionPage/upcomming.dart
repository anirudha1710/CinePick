import 'dart:convert';
import 'package:cine_pick/apikey/apikey.dart';
import 'package:cine_pick/repeatedfunction/repttext.dart';
import 'package:cine_pick/repeatedfunction/slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Upcomming extends StatefulWidget {
  const Upcomming({super.key});

  @override
  State<Upcomming> createState() => _UpcommingState();
}

class _UpcommingState extends State<Upcomming> {
  List<Map<String, dynamic>> getUpcomminglist = [];

  Future<void> getUpcomming() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (var i = 0; i < json['results'].length; i++) {
        getUpcomminglist.add(
          {
            "poster_path": json['results'][i]['poster_path'],
            "name": json['results'][i]['title'],
            "vote_average": json['results'][i]['vote_average'],
            "Date": json['results'][i]['release_date'],
            "id": json['results'][i]['id'],
          },
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUpcomming(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sliderList(getUpcomminglist, "Upcomming", "movie", 20),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
                    child: tittleText("Many More Coming Soon... "))
              ]);
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.amber));
        }
      },
    );
  }
}
