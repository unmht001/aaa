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
        // child: Container(width: 400, height: 400, color: Colors.black, child: cellBuild(this.widget.sdkdata)));
        child: cellBuild(this.widget.sdkdata));
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
    "gridbackgroundcolor": Colors.red,
    "containergroundcolor": Colors.black,
    
  };
  // var minicelltextspace=0.0;
  var minicelltextfontsize=9.0;
  var minicellspace=1.0;  
  var minicellpadding=minicellspace/2;
  var minicellsize=minicellpadding*2+minicelltextfontsize;
  var valuefontsize=minicellpadding*2+minicellsize*3;

  var cellspace=1.0;
  var cellpadding=cellspace/2;
  var cellsize=cellpadding*4+minicellsize*3;

  var gridspace=1.0;  
  var gridpadding=gridspace/2;  
  var gridsize=gridpadding*4+cellsize*3;
  
  var containerpadding=gridspace;
  var containersize=gridspace*4+gridsize*3;    
  
  


  
  
  


  var _f1 = (int v1) {
    return Container(
        width: minicellsize,
        height: minicellsize,
        alignment: Alignment.center,
        padding: EdgeInsets.all(minicellpadding),
        color: thema["minicellbackground"],
        child: Text(v1.toString(), style: TextStyle(color: thema["minicellfontcolor"], fontSize: minicelltextfontsize)));
  };

  var _f2 = (List v2) {
    //v2 [list<int> a:[1,2,3,4,5,6,7,8,9],int b in [0,1,2,3,4,5,6,7,8,9,] : 0 ,bool c : false // 是否显示b值]

    if (v2[2] == false) {
      return Container(
          width: cellsize,
          height: cellsize,
          padding: EdgeInsets.all(cellpadding),
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
          width: cellsize,
          height: cellsize,
          padding: EdgeInsets.all(cellpadding),
          color: thema["cellbackgroundcolor"],
          alignment: Alignment.center,
          child: Text(v2[1] == 0 ? "" : v2[1].toString(), style: TextStyle(fontSize: valuefontsize)));
    }
  };

  var _f3 = (List v3, int gridindex) {
    return Container(
        width: gridsize,
        height: gridsize,
        padding: EdgeInsets.all(gridpadding),
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
    color: thema["containergroundcolor"],
    width: containersize,
    height:containersize,
    alignment: Alignment.center,
      padding: EdgeInsets.all(containerpadding),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 0), _f3(v, 1), _f3(v, 2)]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 3), _f3(v, 4), _f3(v, 5)]),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[_f3(v, 6), _f3(v, 7), _f3(v, 8)])
  ]));
}
