import 'package:flutter/material.dart';
import 'package:flutter_app_movie/detail_page.dart';
import 'package:flutter_app_movie/movie.dart';
import 'package:provider/provider.dart';
import 'movie_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieInfo>(create: (_) => MovieInfo()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<MovieInfo>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    MovieInfo movieInfo = Provider.of(context);
    Movie result = movieInfo.result;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('영화 정보 검색기'),
      ),
      body: Column(
        children: [
        TextField(
        controller: movieInfo.controller,
        onChanged: (text) {
          setState(() {
            movieInfo.filteredItems.clear();
            for (var item in movieInfo.result.results) {
              if (item.title.contains(text)) {
                movieInfo.filteredItems.add(item);
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
            children: result == null ? [] : _buildItems(),
      ),
    ),]
    ,
    )
    ,
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
              child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movies.posterPath}'),
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
    MovieInfo movieInfo = Provider.of(context);
    Movie result = movieInfo.result;

    if (movieInfo.controller.text.isEmpty) {
      return result.results.map((e) => _buildItem(e)).toList();
    }
    return movieInfo.filteredItems.map((e) => _buildItem(e)).toList();
  }
}