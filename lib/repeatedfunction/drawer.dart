import 'package:cine_pick/sectionPage/favouriteList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'repttext.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class drawerFunc extends StatefulWidget {
  const drawerFunc({
    super.key,
  });

  @override
  State<drawerFunc> createState() => _drawerFuncState();
}

class _drawerFuncState extends State<drawerFunc> {
  File? _image;

  Future<void> selectImage() async {}

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (sp) {
        setState(
          () {
            _image = File(sp.getString('imagePath')!);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromRGBO(18, 18, 18, 0.9),
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await selectImage();
                      //toast message
                      Fluttertoast.showToast(
                          msg: "Image Changed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: _image == null
                        ? const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/user.png'),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_image!),
                          ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            listTitleFunc(
              'Home',
              Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            listTitleFunc(
              'Favorite',
              Icons.favorite,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriateMovies()));
              },
            ),
            listTitleFunc(
              'Our Blogs',
              FontAwesomeIcons.blogger,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.5),
                      appBar: AppBar(
                        backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
                        title: const Text('Our Blogs'),
                      ),
                      body: WebViewWidget(
                        controller: WebViewController(),
                      ),
                    ),
                  ),
                );
              },
            ),
            listTitleFunc(
              'Our Website',
              FontAwesomeIcons.solidNewspaper,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.5),
                      appBar: AppBar(
                        backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
                        title: const Text('Our Website'),
                      ),
                    ),
                  ),
                );
              },
            ),
            listTitleFunc(
              'Subscribe US',
              FontAwesomeIcons.youtube,
              onTap: () async {
                var url =
                    'https://www.youtube.com/channel/UCeJnnsTq-Lh9E16kCEK49rQ?sub_confirmation=1';
                await launch(url);
              },
            ),
            listTitleFunc(
              'About',
              Icons.info,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
                      title: overviewtext(
                          'This App is made by Anirudha Sharma .User can explore,get Details of latest Movies/series.TMDB API is used to fetch data.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'))
                      ],
                    );
                  },
                );
              },
            ),
            listTitleFunc('Quit', Icons.exit_to_app_rounded, onTap: () {
              SystemNavigator.pop();
            }),
          ],
        ),
      ),
    );
  }
}

Widget listTitleFunc(String title, IconData icon, {Function? onTap}) {
  return GestureDetector(
    onTap: onTap as void Function()?,
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
