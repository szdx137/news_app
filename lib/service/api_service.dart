import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';
import 'dart:convert';
import '../model/login_model.dart';
import 'package:path_provider/path_provider.dart';

class APIService {
  List<Article> articles = [];
  List<Article> articleCategory = [];

  String cacheFileName = "CacheData.json";

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = "https://reqres.in/api/login";

    final response =
        await http.post(Uri.parse(url), body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('got some response');

      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<void> getNewsModel(String token, bool refresh) async {
    // if (token == 'QpwL5tke4Pnpja7X4') {
    //   token = '4973c567a7844dba8cd3d622a1138438';
    // }

    //checking if it is refresh, if yes then only load from api and save in cache
    if (refresh) {
      //to test if regfreshed
      // String url =
      //     'http://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=4973c567a7844dba8cd3d622a1138438';

      String url =
          'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=4973c567a7844dba8cd3d622a1138438';

      final response = await http.get(Uri.parse(url));
      var jsonResponse = response.body;
      var jsonData = jsonDecode(jsonResponse);
      if (jsonData['status'] == 'ok') {
        print('refreshing data');
        print('Loading from API: got response from news api');

        for (var article in NewsResponseModel.fromJson(jsonData).articles) {
          articles.add(article);
        }
        var tempDir = await getTemporaryDirectory();
        File file = new File(tempDir.path + "/" + cacheFileName);
        file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
      } else {
        throw Exception('Failed to load data!');
      }
    }

    var cacheDir = await getTemporaryDirectory();

    //check in cache
    if (await File(cacheDir.path + "/" + cacheFileName).exists()) {
      print("Loading from cache");
      //TOD0: Reading from the json File
      var jsonResponse =
          File(cacheDir.path + "/" + cacheFileName).readAsStringSync();
      var jsonData = jsonDecode(jsonResponse);

      for (var article in NewsResponseModel.fromJson(jsonData).articles) {
        articles.add(article);
      }
    } else {
      String url =
          'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=4973c567a7844dba8cd3d622a1138438';
      final response = await http.get(Uri.parse(url));
      var jsonResponse = response.body;
      var jsonData = jsonDecode(jsonResponse);
      if (jsonData['status'] == 'ok') {
        print('Loading from API: got response from news api');

        for (var article in NewsResponseModel.fromJson(jsonData).articles) {
          articles.add(article);
        }
        var tempDir = await getTemporaryDirectory();
        File file = new File(tempDir.path + "/" + cacheFileName);
        file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
      } else {
        throw Exception('Failed to load data!');
      }
    }
  }

  Future<void> getNewsModelCategory({String category}) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=4973c567a7844dba8cd3d622a1138438';

    final response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      print('get response from news api CATEGORY');

      for (var article in NewsResponseModel.fromJson(jsonData).articles) {
        articleCategory.add(article);
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
