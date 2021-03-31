import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/view/detail_news.dart';

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url, publishedAtDate, publishedAtTime;

  BlogTile(
      {this.desc,
      this.imageUrl,
      this.title,
      this.url,
      this.publishedAtDate,
      this.publishedAtTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(
              blogUrl: url,
            ),
          ),
        );
      },
      child: Card(
        //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: imageUrl ??
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png',
                placeholder: (context, url) {
                  return Container(
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              style: TextStyle(fontWeight: FontWeight.w300),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              child: Row(
                children: [
                  Icon(Icons.date_range),
                  Text(
                    publishedAtDate,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.access_time),
                  Text(
                    publishedAtTime,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
