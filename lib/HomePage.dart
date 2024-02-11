import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              ],
            ),
          )
        ],
      ),
    );
  }
}


// https:api.themoviedb.org/3/movie/upcoming?api_key=$apikey'