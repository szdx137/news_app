import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:news_app/service/data.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/service/api_service.dart';
import 'package:news_app/view/blog_tile.dart';
import 'package:news_app/view/category_news.dart';
import 'package:news_app/view/category_tile.dart';
import 'package:news_app/view/detail_news.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = true;
  List<CategoryModel> categories = [];
  List<Article> articlesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.categories = getCategories();
    getNews(false);
  }

  getNews(bool refresh) async {
    isLoading = true;
    setState(() {
      if (isLoading) CircularProgressIndicator();
    });
    APIService apiService = new APIService();
    await apiService.getNewsModel('token', refresh);
    this.articlesList = apiService.articles;
    setState(() {
      isLoading = false;
    });
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        Navigator.of(context).pushReplacementNamed("/");

        break;
      // case 'Settings':
      //   print('in settings');
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Today\'s news'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure?',
                    ),
                    content: Text('It will close the application.'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                    ],
                  ));
        },
        child: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await getNews(true);
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Column(
                        children: <Widget>[
                          /// Categories
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            height: 70,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return CategoryTile(
                                    imageUrl: categories[index].imageUrl,
                                    caregoryName:
                                        categories[index].categoryName,
                                  );
                                }),
                          ),

                          /// News Article
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: ListView.builder(
                                itemCount: articlesList.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: BlogTile(
                                      imageUrl:
                                          articlesList[index].urlToImage ?? "",
                                      title: articlesList[index].title ?? "",
                                      desc:
                                          articlesList[index].description ?? "",
                                      url: articlesList[index].url,
                                      publishedAtDate: DateFormat("yyyy-MM-dd")
                                          .format(
                                              articlesList[index].publishedAt),
                                      publishedAtTime: DateFormat("h:mma")
                                          .format(
                                              articlesList[index].publishedAt),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
