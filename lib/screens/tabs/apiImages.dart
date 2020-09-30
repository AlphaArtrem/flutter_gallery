import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery/classes/apiImageModel.dart';
import 'package:flutter_gallery/classes/unsplashAPI.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ApiImages extends StatefulWidget {
  @override
  _ApiImagesState createState() => _ApiImagesState();
}

class _ApiImagesState extends State<ApiImages> {
  ScrollController _controller = ScrollController();
  List<ImageModel> _images = [];
  bool _loadingFirst = true;
  bool _loadingSubsequent = false;
  int _currentPage = 1;
  int _maxPages = 1;
  double _widthOne;
  double _heightOne;
  double _fontOne;
  double _iconOne;

  @override
  void initState() {
    _controller.addListener(() {
      if(_controller.position.atEdge &&
          _controller.position.pixels != 0 && _currentPage <= _maxPages){
        _loadingSubsequent = true;
        setState(() {});
        setup();
      }
    });
    super.initState();
    setup();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _widthOne = size.width * 0.0008;
    _heightOne = (size.height * 0.007) / 5;
    _fontOne = (size.height * 0.015) / 11;
    _iconOne = (size.height * 0.066) / 50;
    if(_loadingFirst){
      return Center(
        child: SpinKitThreeBounce(
          color: Colors.deepPurpleAccent,
          size: _iconOne * 30,
        ),
      );
    }else if(_images == null){
      return Center(
        child: Text(
          "Couldn't Fetch Images",
          maxLines: 1,
          style: TextStyle(
              color: Colors.grey,
              fontSize: _fontOne * 18,
              fontWeight: FontWeight.w500
          ),
        ),
      );
    }else{
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
                controller: _controller,
                padding: EdgeInsets.symmetric(
                  horizontal: _widthOne * 100,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.525
                ),
                itemCount: _images.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    _images[index].imageRegular,
                                  ),
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: _widthOne * 40,
                            bottom: _heightOne * 10,
                            right: _widthOne * 50
                        ),
                        child: Text(
                          _images[index].name,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: _fontOne * 12,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
          _loadingSubsequent ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: SpinKitPulse(
              size: _iconOne * 20,
              color: Colors.deepPurpleAccent,
            ),
          ) : Container()
        ],
      );
    }
  }

  void setup() async{
    /*
      Since both collection give same images no need to get data twice

      List<ImageModel> imageCollectionOne =
      await UnSplashAPI().getUnSplashImages(collection: 0);
      List<ImageModel> imageCollectionTwo =
      await UnSplashAPI().getUnSplashImages(collection: 0);
      if(imageCollectionOne != null || imageCollectionTwo != null){
        if(imageCollectionOne != null){
          _images.addAll(imageCollectionOne);
        }
        if(imageCollectionTwo != null){
          _images.addAll(imageCollectionTwo);
        }
        _images.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }else{
        _images = null;
      }
    */
    List<ImageModel> images;
    if(_currentPage == 1){
      FirstPage firstPage = await UnSplashAPI().getFirstPage(collection: 0);
      if(firstPage != null){
        _maxPages = firstPage.totalPages;
        _images.addAll(firstPage.images);
        _currentPage ++;
      }else{
        _images = null;
      }
      _loadingFirst = false;
    }else{
      List<ImageModel> images =
      await UnSplashAPI().getOtherPages(collection: 0, page: _currentPage);
      if(images != null){
        _images.addAll(images);
        _currentPage ++;
      }
      _loadingSubsequent = false;
    }
    setState(() {});
  }
}
