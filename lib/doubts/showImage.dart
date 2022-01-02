import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  ShowImage({@required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Image.network(image),
      ),
    );
  }
}
