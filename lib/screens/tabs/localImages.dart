import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class LocalImages extends StatefulWidget {
  @override
  _LocalImagesState createState() => _LocalImagesState();
}

class _LocalImagesState extends State<LocalImages> {
  List<MediaFile> _images = [];
  double _widthOne;
  double _heightOne;
  double _fontOne;
  double _iconOne;

  void setup() async{
    await checkPermission();
    await MediaPickerBuilder.getAlbums(
        withImages: true,
        withVideos: false
    ).then((albums){
      albums.forEach((album) {
        album.files.forEach((file) {
          _images.add(file);
        });
      });
    });
    setState(() {});
  }

  @override
  void initState() {
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
    return _images.isEmpty ? Center(
      child: SpinKitThreeBounce(
        color: Colors.deepPurpleAccent,
        size: _iconOne * 30,
      ),
    ) : GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: _widthOne * 30,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6
        ),
        itemCount: _images.length,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: FileImage(
                  File(_images[index].path),
                ),
                fit: BoxFit.cover
              )
            ),
          );
        }
    );
  }

  Future<bool> checkPermission() async {
    final permissionStorageGroup =
    Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
    Map<PermissionGroup, PermissionStatus> res =
    await PermissionHandler().requestPermissions([
      permissionStorageGroup,
    ]);
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }
}
