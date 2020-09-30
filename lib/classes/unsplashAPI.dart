import 'package:flutter_gallery/classes/apiImageModel.dart';
import 'package:flutter_gallery/env.dart';
import 'package:http/http.dart';
import 'dart:convert';

class UnSplashAPI{
  final List<String> _collections = [
    'https://api.unsplash.com/collections/1580860/photos?client_id=$apiKey&per_page=30',
    "https://api.unsplash.com/collections/139386/photos?client_id=$apiKey&per_page=30"
  ];

  Future<FirstPage> getFirstPage({int collection}) async{
    try{
      List<ImageModel> images = [];

      Response response = await get(_collections[collection]);
      int totalImages = int.parse(response.headers['x-total']);
      int imagesPerPage = int.parse(response.headers['x-per-page']);
      List data = jsonDecode(response.body);
      int totalPages = (totalImages / imagesPerPage).ceil();

      for(int i = 0; i < data.length; i++){
        try{
          images.add(ImageModel.formMap(data[i]));
        }catch(e){
          print(e.toString());
        }
      }

      return FirstPage(
        totalPages: totalPages,
        images: images
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<List<ImageModel>> getOtherPages({int collection, int page}) async{
    try{
      List<ImageModel> images = [];
      Response response = await get(_collections[collection] + "&page=$page");
      List data = jsonDecode(response.body);

      for(int i = 0; i < data.length; i++){
        try{
          images.add(ImageModel.formMap(data[i]));
        }catch(e){
          print(e.toString());
        }
      }

      return images;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}

class FirstPage{
  int totalPages;
  List<ImageModel> images;

  FirstPage({
    this.totalPages,
    this.images,
});
}