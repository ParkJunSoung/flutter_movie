import 'package:flutter/material.dart';
import 'package:flutter_app_movie/detail_page.dart';
import 'package:flutter_app_movie/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Results> filteredItems = [];
  List<Results> movies = [];
  final _controller = TextEditingController();


  Future<Movie> fetchData() async {
    var uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=a64533e7ece6c72731da47c9c8bc691f&language=ko-KR&page=1');
    var response = await http.get(uri);

    Movie result = Movie.fromJson(json.decode(response.body));
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((airResult) {
      setState(() {
        for (int i = 0; i < airResult.results.length; i++) {
          movies.add(airResult.results[i]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('영화 정보 검색기'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: (text) {
              setState(() {
                filteredItems.clear();
                for (var item in movies) {
                  if (item.title.contains(text)) {
                    filteredItems.add(item);
                  }
                }
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(40)),
              labelText: '검색',
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2 / 3.7,
              children: _buildItems(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildItem(Results movies) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(movies)),
        );
      },
      child: Column(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Hero(
              tag: movies.posterPath,
              child: Image.network('https://image.tmdb.org/t/p/w500/${movies.posterPath}'),
              ),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                movies.title,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _buildItems() {
    if (_controller.text.isEmpty) {
      return movies.map((e) => _buildItem(e)).toList();
    }
    return filteredItems.map((e) => _buildItem(e)).toList();
  }

}