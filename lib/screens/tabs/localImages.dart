import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
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
    _images.sort((a, b){
      if(a.dateAdded > b.dateAdded){
        return -1;
      }else if(a.dateAdded < b.dateAdded){
        return 1;
      }else{
        return 0;
      }
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
          horizontal: _widthOne * 100,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.525
        ),
        itemCount: _images.length + 1,
        itemBuilder: (context, index){
          if(index == 0){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      PickedFile pickedFile = await ImagePicker().getImage(
                        source: ImageSource.camera
                      );
                      await GallerySaver.saveImage(
                          pickedFile.path,
                          albumName: "FlutterGalley"
                      ).then((success){
                        if(success){
                          List<MediaFile> images = [MediaFile(path: pickedFile.path,)];
                          images.addAll(_images);
                          _images = images;
                          setState(() {});
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Image saved Successfully in FlutterGalley album"
                                ),
                              )
                          );
                        }else{
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Couldn't save image"
                                ),
                              )
                          );
                        }
                      });
                    },
                    child: Container(
                      width: size.width,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.5)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: _iconOne * 50,
                          ),
                          SizedBox(height: _heightOne * 10,),
                          Text(
                            "Take A Photo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _fontOne * 12,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),
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
                    "Camera",
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: _fontOne * 12,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: FileImage(
                        File(_images[index - 1].path),
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
                  _images[index].fileName,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: _fontOne * 12,
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
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
