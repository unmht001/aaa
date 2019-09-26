import 'package:flutter/material.dart';
import 'tt1.dart';

class Page4 extends StatefulWidget {
  final Widget child;

  Page4({Key key, this.child}) : super(key: key);

  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    try {
      return SdkGrid();
    } catch (e) {
      print("Page4:error \n ${e.toString()}");
      return Container(
        child: Text(e.toString()),
      );
    }
  }
}

var st = "data";
