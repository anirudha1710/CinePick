import 'package:cine_pick/details/movies.dart';
import 'package:cine_pick/details/tvseriesdetail.dart';
import 'package:cine_pick/repeatedfunction/repttext.dart';
import 'package:flutter/material.dart';

Widget sliderList(
    List firstListName, String categoryTittle, String type, itemLength) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
          child: tittleText(categoryTittle)),
      SizedBox(
        height: 250,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: itemLength,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (type == 'movie') {
                  // print(firstlistname[index]['id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieDetails(
                                id: firstListName[index]['id'],
                              )));
                } else if (type == 'tv') {
                  // print(first list name[index]['id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              tvSeriesDetail(id: firstListName[index]['id'])));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken),
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${firstListName[index]['poster_path']}'),
                        fit: BoxFit.cover)),
                margin: const EdgeInsets.only(left: 13),
                width: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 2, left: 6),
                        child: dateText(firstListName[index]['Date'])),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 2, left: 5, right: 5),
                          child: Row(
                            //row for rating
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 15),
                              const SizedBox(width: 2),
                              ratingText(firstListName[index]['vote_average']
                                  .toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 20)
    ],
  );
}
