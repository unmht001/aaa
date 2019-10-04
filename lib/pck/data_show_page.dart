import 'dart:math';

// import 'package:aaa/data.dart';
import 'package:aaa/pck/data_type_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataShowPage extends StatefulWidget {
  @override
  _DataShowPageState createState() => _DataShowPageState();
}

class _DataShowPageState extends State<DataShowPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: MapToWidget(App.instance.database),
        )));
  }
}
class MapToWidget extends StatelessWidget {
  MapToWidget(this.data);
  final data;
  @override
  Widget build(BuildContext context) {
    if (data is Map) {
      List<Widget> a = <Widget>[];
      for (var item in data.keys.toList()) {
        a.add( Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[MapToWidget(item), MapToWidget(data[item])]));
      }
      return Container(
        child: Column(children: a),
        color: Color.fromRGBO(160, 160, Random().nextInt(80) + 160 ,
            Random().nextInt(100) + 150 / 255),
      );
    } else if (data is List) {
      List<Widget> a = <Widget>[];
      for (var item in data.toList()) {
        a.add(MapToWidget(item));
      }
      return Container(
          alignment: Alignment.centerLeft,
          color: Color.fromRGBO(Random().nextInt(80) + 160, 0, 0 , 
              Random().nextInt(100) + 150 / 255),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: a));
    } else {
      return Container(
        padding: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(Random().nextInt(80)+160, Random().nextInt(80) + 160, Random().nextInt(80) + 160,
            Random().nextInt(100) + 150 / 255),
        child: Text(data.toString(), softWrap: true),
      );
    }
  }
}
