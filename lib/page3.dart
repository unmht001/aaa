import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  final Widget child;
  final List sdkdata;
  Page3({Key key, this.child, this.sdkdata}) : super(key: key);

  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.greenAccent,
        alignment: Alignment.center,
        child: Container(width: 400, height: 400, color: Colors.black, child: cellBuild(this.widget.sdkdata)));
  }
}

int gridpostion2globalposition(int gridindex, int gridposition) {
  return 27 * (gridindex ~/ 3) + 3 * (gridindex % 3) + 9 * (gridposition ~/ 3) + (gridposition % 3);
}

Widget cellBuild(List v) {
  //v=list<v2> []

  Map<String, Color> thema = {
    "minicellbackground": Colors.white,
    "minicellfontcolor": Colors.black,
    "cellbackgroundcolor": Colors.brown,
    "gridbackgroundcolor": Colors.red
  };

  var _f1 = (int v1) {
    return Container(
        width: 13,
        height: 13,
        alignment: Alignment.center,
        padding: EdgeInsets.all(1),
        color: thema["minicellbackground"],
        child: Text(v1.toString(), style: TextStyle(color: thema["minicellfontcolor"], fontSize: 10.0)));
  };

  var _f2 = (List v2) {
    //v2 [list<int> a:[1,2,3,4,5,6,7,8,9],int b in [0,1,2,3,4,5,6,7,8,9,] : 0 ,bool c : false // 是否显示b值]

    if (v2[2] == false) {
      return Container(
          width: 41,
          height: 41,
          padding: EdgeInsets.all(0),
          color: thema["cellbackgroundcolor"],
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_f1(v2[0][0]), _f1(v2[0][1]), _f1(v2[0][2])]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_f1(v2[0][3]), _f1(v2[0][4]), _f1(v2[0][5])]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_f1(v2[0][6]), _f1(v2[0][7]), _f1(v2[0][8])])
          ]));
    } else {
      return Container(
          width: 41,
          height: 41,
          padding: EdgeInsets.all(1),
          color: thema["cellbackgroundcolor"],
          alignment: Alignment.center,
          child: Text(v2[1] == 0 ? "" : v2[1].toString(), style: TextStyle(fontSize: 36)));
    }
  };

  var _f3 = (List v3, int gridindex) {
    return Container(
        width: 127,
        height: 127,
        padding: EdgeInsets.all(1),
        color: thema["gridbackgroundcolor"],
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            _f2(v3[gridpostion2globalposition(gridindex, 0)]),
            _f2(v3[gridpostion2globalposition(gridindex, 1)]),
            _f2(v3[gridpostion2globalposition(gridindex, 2)])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            _f2(v3[gridpostion2globalposition(gridindex, 3)]),
            _f2(v3[gridpostion2globalposition(gridindex, 4)]),
            _f2(v3[gridpostion2globalposition(gridindex, 5)])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            _f2(v3[gridpostion2globalposition(gridindex, 6)]),
            _f2(v3[gridpostion2globalposition(gridindex, 7)]),
            _f2(v3[gridpostion2globalposition(gridindex, 8)])
          ])
        ]));
  };

  return Container(
      padding: EdgeInsets.all(5),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 0), _f3(v, 1), _f3(v, 2)]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 3), _f3(v, 4), _f3(v, 5)]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 6), _f3(v, 7), _f3(v, 8)])
  ]));
}
