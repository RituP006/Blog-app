import 'package:flutter/material.dart';

class PostsUI extends StatelessWidget {
  final String image;
  final String description;
  final String date;
  final String time;

  PostsUI(this.image, this.description, this.date, this.time);
  @override
  Widget build(BuildContext context) {
    print('image url in PostUI: $image');
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
