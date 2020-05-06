import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String data;
  ImageViewer({
    Key key,
    @required this.data
  }) : super(key: key);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          PhotoView(
            imageProvider: AssetImage(widget.data),
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
