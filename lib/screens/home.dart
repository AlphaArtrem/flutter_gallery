import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery/screens/tabs/apiImages.dart';
import 'package:flutter_gallery/screens/tabs/localImages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _widthOne;
  double _heightOne;
  double _fontOne;
  double _iconOne;
  int _currentIndex = 0;
  List<Widget> _tabBody = [
    ApiImages(),
    LocalImages()
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _widthOne = size.width * 0.0008;
    _heightOne = (size.height * 0.007) / 5;
    _fontOne = (size.height * 0.015) / 11;
    _iconOne = (size.height * 0.066) / 50;
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Gallery"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: (){}
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topButtons(),
            Expanded(child: _tabBody[_currentIndex])
          ],
        ),
      ),
    );
  }

  Widget topButtons(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.purple
        )
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _widthOne * 50,
        vertical: _heightOne * 20
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                if(_currentIndex != 0){
                  setState(() {
                    _currentIndex = 0;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: _heightOne * 5
                ),
                decoration: BoxDecoration(
                    color:  _currentIndex != 0  ? Colors.white :
                    Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "API",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _currentIndex != 0 ? Colors.black : Colors.white ,
                      fontWeight: FontWeight.w500,
                      fontSize: _fontOne * 15
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: (){
                if(_currentIndex != 1){
                  setState(() {
                    _currentIndex = 1;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: _heightOne * 5
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:  _currentIndex != 1  ? Colors.white :
                    Colors.purple,
                ),
                child: Text(
                  "Local",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _currentIndex != 1 ? Colors.black : Colors.white ,
                      fontWeight: FontWeight.w500,
                      fontSize: _fontOne * 15
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
