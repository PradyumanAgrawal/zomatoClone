import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/functionalities/route_generator.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  String data;
  ImageViewer(String data) {
    this.data = data;
  }
  @override
  _ImageViewerState createState() => _ImageViewerState(data);
}

class _ImageViewerState extends State<ImageViewer> {
  String image;
  _ImageViewerState(String data) {
    image = data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          PhotoView(
            imageProvider: AssetImage(image),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            enableRotation: false,
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }
}
