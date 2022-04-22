import 'package:examcreative/main.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class viewpage extends StatefulWidget {
  String? image;
  int index;

  viewpage(this.image, this.index);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: PhotoView(
          imageProvider: NetworkImage("${widget.image}"),
      ),
    ),
        ));
  }
}
