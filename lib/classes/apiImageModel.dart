import 'package:flutter/cupertino.dart';

class ImageModel{
  DateTime timestamp;
  String name;
  String imageRegular;
  String imageLarge;
  int width;
  int height;

  ImageModel({
    @required this.width,
    @required this.height,
    @required this.timestamp,
    @required this.imageLarge,
    @required this.imageRegular,
    @required this.name
  }) : assert(
    width != null && height != null && timestamp != null
    && imageRegular != null && imageRegular != null && name != null
  );

  static ImageModel formMap(Map data){
    return ImageModel(
        width: data["width"],
        height: data["height"],
        timestamp: DateTime.parse(data["updated_at"]),
        imageLarge: data["urls"]["full"],
        imageRegular: data["urls"]["regular"],
        name: data["description"] == null ? "Not Found" : data["description"]
    );
  }
}