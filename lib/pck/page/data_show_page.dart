import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data_type.dart' show App;


class DataShowPage extends StatefulWidget {
  @override
  _DataShowPageState createState() => _DataShowPageState();
}

class _DataShowPageState extends State<DataShowPage> with SingleTickerProviderStateMixin {
  TabController _tbc;
  @override
  void initState() {
    super.initState();
    _tbc = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tbc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: TabBar(controller: _tbc, tabs: <Widget>[
              FlatButton(child: Text(1.toString()), onPressed: () {_tbc.animateTo(0);}),
              FlatButton(child: Text(2.toString()), onPressed: () {_tbc.animateTo(1);})
            ]),
            body: TabBarView(controller: _tbc, children: <Widget>[
              Container(child: SingleChildScrollView(child:Text(App.logString, softWrap: true))),
              Container(
                  child: SingleChildScrollView(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, child: MapToWidget(App.instance.database))))
            ])));
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
        a.add(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[MapToWidget(item), MapToWidget(data[item])]));
      }
      return Container(
        child: Column(children: a),
        color: Color.fromRGBO(160, 160, Random().nextInt(80) + 160, Random().nextInt(100) + 150 / 255),
      );
    } else if (data is List) {
      List<Widget> a = <Widget>[];
      for (var item in data.toList()) {
        a.add(MapToWidget(item));
      }
      return Container(
          alignment: Alignment.centerLeft,
          color: Color.fromRGBO(Random().nextInt(80) + 160, 0, 0, Random().nextInt(100) + 150 / 255),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: a));
    } else {
      return Container(
        padding: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(Random().nextInt(80) + 160, Random().nextInt(80) + 160, Random().nextInt(80) + 160,
            Random().nextInt(100) + 150 / 255),
        child: Text(data.toString(), softWrap: true),
      );
    }
  }
}
