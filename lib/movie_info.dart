import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'movie.dart';

class MovieInfo extends ChangeNotifier {
  final List<Results> filteredItems = [];
  final controller = TextEditingController();
  Movie _result;

  Movie get result => _result;

  Future<Movie> fetchData() async {
    var uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=a64533e7ece6c72731da47c9c8bc691f&language=ko-KR&page=1');
    var response = await http.get(uri);
    Movie result = Movie.fromJson(json.decode(response.body));
    this._result = result;
    notifyListeners();
  }
}
