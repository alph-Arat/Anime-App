import 'package:flutter/material.dart';
import 'naruto_page.dart';
class CustomFuture extends StatelessWidget {
  final Album custom;
  const CustomFuture({Key? key,required this.custom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.full);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
