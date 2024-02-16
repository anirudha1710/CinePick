import 'package:cine_pick/apikey/apikey.dart';
import 'package:cine_pick/details/checker.dart';
import 'package:cine_pick/repeatedfunction/repttext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

class searchBarFun extends StatefulWidget {
  const searchBarFun({super.key});

  @override
  State<searchBarFun> createState() => _searchBarFunState();
}

class _searchBarFunState extends State<searchBarFun> {
  //search bar function//
  List<Map<String, dynamic>> searchresult = [];

  Future<void> searchlistfunction(val) async {
    var searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=$apikey&query=$val';
    var searchResponse = await http.get(Uri.parse(searchUrl));
    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];
      for (var i = 0; i < searchJson.length; i++) {
        //only add value if all are present
        if (searchJson[i]['id'] != null &&
            searchJson[i]['poster_path'] != null &&
            searchJson[i]['vote_average'] != null &&
            searchJson[i]['media_type'] != null) {
          searchresult.add(
            {
              'id': searchJson[i]['id'],
              'poster_path': searchJson[i]['poster_path'],
              'vote_average': searchJson[i]['vote_average'],
              'media_type': searchJson[i]['media_type'],
              'popularity': searchJson[i]['popularity'],
              'overview': searchJson[i]['overview'],
            },
          );

          // search result = search result.toSet().toList();

          if (searchresult.length > 20) {
            searchresult.removeRange(20, searchresult.length);
          }
        } else {
          print('null value found');
        }
      }
    }
  }

  final TextEditingController searchText = TextEditingController();
  bool showList = false;
  var val1;

  //search bar function//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("tapped");
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: TextField(
                autofocus: false,
                controller: searchText,
                onSubmitted: (value) {
                  searchresult.clear();
                  setState(
                    () {
                      val1 = value;
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                },
                onChanged: (value) {
                  searchresult.clear();

                  setState(
                    () {
                      val1 = value;
                    },
                  );
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            webBgColor: "#000000",
                            webPosition: "center",
                            webShowClose: true,
                            msg: "Search Cleared",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor:
                                const Color.fromRGBO(18, 18, 18, 1),
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          searchText.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.amber.withOpacity(0.6),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.amber,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                    border: InputBorder.none),
              ),
            ),
            //
            //
            const SizedBox(
              height: 5,
            ),

            //if text field has focus and search result is not empty then display search result

            searchText.text.length > 0
                ? FutureBuilder(
                    future: searchlistfunction(val1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: searchresult.length,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DescriptionCheckUi(
                                        searchresult[index]['id'],
                                        searchresult[index]['media_type'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(20, 20, 20, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            image: DecorationImage(
                                                //color filter

                                                image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500${searchresult[index]['poster_path']}'),
                                                fit: BoxFit.fill)),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: tittleText(
                                                '${searchresult[index]['media_type']}',
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                //vote average box
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  height: 30,
                                                  // width:
                                                  //     100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.amber
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  6))),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        ratingText(
                                                            '${searchresult[index]['vote_average']}')
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                //popularity
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.amber
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8))),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .people_outline_sharp,
                                                          color: Colors.amber,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        ratingText(
                                                            '${searchresult[index]['popularity']}')
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                //
                                              ],
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: 85,
                                                child: Text(
                                                    textAlign: TextAlign.left,
                                                    ' ${searchresult[index]['overview']}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.amber,
                        ));
                      }
                    })
                : Container(),
          ],
        ),
      ),
    );
  }
}
