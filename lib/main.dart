import 'package:flutter/material.dart';
import 'package:flutter_gallery/screens/home.dart';

void main() {
  runApp(FlutterGallery());
}

class FlutterGallery extends StatefulWidget {
  @override
  _FlutterGalleryState createState() => _FlutterGalleryState();
}

class _FlutterGalleryState extends State<FlutterGallery> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
      debugShowCheckedModeBanner: false,
      title: "Flutter Gallery",
      home: Home(),
    );
  }
}
