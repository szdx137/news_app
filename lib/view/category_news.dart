import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/service/api_service.dart';
import 'package:news_app/view/blog_tile.dart';

class CategoryNews extends StatefulWidget {
  @override
  _CategoryNewsState createState() => _CategoryNewsState();

  String category;
  CategoryNews({this.category});
}

class _CategoryNewsState extends State<CategoryNews> {
  var isLoading = true;
  List<Article> articlesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsCategory();
  }

  getNewsCategory() async {
    APIService apiService = new APIService();
    await apiService.getNewsModelCategory(category: widget.category);
    this.articlesList = apiService.articleCategory;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.category.toUpperCase()),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ListView.builder(
                    itemCount: articlesList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BlogTile(
                          imageUrl: articlesList[index].urlToImage ?? "",
                          title: articlesList[index].title ?? "",
                          desc: articlesList[index].description ?? "",
                          url: articlesList[index].url,
                          publishedAtDate: DateFormat("yyyy-MM-dd")
                              .format(articlesList[index].publishedAt),
                          publishedAtTime: DateFormat("h:mma")
                              .format(articlesList[index].publishedAt),
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
