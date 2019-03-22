import 'package:flutter/material.dart';
// import 'package:sliver_glue/sliver_glue.dart';

final List<String> thistext = <String>['1', '2', "3", '1', '2', "3", '1', '2', "3"];

class Sdkcell {
  List valuebox = [1, 2, 3, 4, 5, 6, "", 8, 9];
  int value = 0;
  bool showvalue = false;
  int position;

  int get sline => position ~/ 9;
  int get srow => position % 9;
  int get sgrid => (position ~/ 27) * 3 + (position % 9) ~/ 3;
  int get sgindex => ((position ~/ 9) % 3) * 3 + position % 3;

  Sdkcell(this.position) : assert(position != null && position > -1 && position < 81);
}

class Sdkmain {
  List _sdkdt1 = [];

  List get data => _sdkdt1;

  int linerow2pos(int x, int y) => x * 9 + y;
  int gridindex2pos(int x, int y) => (x ~/ 3) * 27 + (x % 3) * 3 + (y ~/ 3) * 9 + y % 3;

  List pos2linerow(int position) => [position ~/ 9, position % 9];
  List pos2gridindex(int position) =>
      [(position ~/ 27) * 3 + (position % 9) ~/ 3, ((position ~/ 9) % 3) * 3 + position % 3];

  Sdkcell getbypos(int x) => _sdkdt1[x];
  Sdkcell getbylinerow(int x, int y) => _sdkdt1[linerow2pos(x, y)];
  Sdkcell getbygridindex(int x, int y) => _sdkdt1[gridindex2pos(x, y)];

  List getLineByPosExceptSelf(int position) {
    var _lr = pos2linerow(position);
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      if (i != _lr[1]) {
        _ret.add(getbylinerow(_lr[0], i));
      }
    }
    return _ret;
  }

  List getRowByPosExceptSelf(int position) {
    var _lr = pos2linerow(position);
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      if (i != _lr[0]) {
        _ret.add(getbylinerow(i, _lr[1]));
      }
    }
    return _ret;
  }

  List getGridByPosExceptSelf(int position) {
    var _gi = pos2linerow(position);
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      if (i != _gi[1]) {
        _ret.add(getbygridindex(_gi[0], i));
      }
    }
    return _ret;
  }

  List getLine(int line) {
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      _ret.add(getbylinerow(line, i));
    }
    return _ret;
  }

  List getRow(int row) {
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      _ret.add(getbylinerow(i, row));
    }
    return _ret;
  }

  List getGrid(int grid) {
    var _ret = [];
    for (var i = 0; i < 9; i++) {
      _ret.add(getbygridindex(grid, i));
    }
    return _ret;
  }

  Sdkmain() {
    for (var i = 0; i < 81; i++) {
      _sdkdt1.add(Sdkcell(i));
    }
  }
}

class SdkGrid extends StatefulWidget {
  final Map mp={
    "ontap":(){},
    "ondown":(){}
  };
  final List data=[[],[]];
  // final List _tmp=[];
  final Sdkmain smin = new Sdkmain();
  SdkGrid({List data,ontap,ondown}){
    if (data!=null){
      this.data[0]=data;
    }
    if (ontap!=null){
      this.mp["ontap"]=ontap;      
    }
    if (ondown!=null){
      this.mp["ondown"]=ondown;
    }
  }
  @override
  _SdkGridState createState() => _SdkGridState();
}

class _SdkGridState extends State<SdkGrid> {
  @override
  Widget build(BuildContext context) {
    try {
      return 
      GestureDetector(
        onTap: this.widget.mp["ontap"],
        onTapDown: this.widget.mp["ondown"],
        child: Container(
          color: Colors.tealAccent,
          alignment: Alignment.center,
          child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((x) {
                return Container(
                    alignment: Alignment.center,
                    color: Colors.red,
                    padding: EdgeInsets.all(1),
                    child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                        children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((y) {
                          return Container(
                              alignment: Alignment.center,
                              color: Colors.blue,
                              padding: EdgeInsets.all(1),
                              child: GridView.count(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 1.0,
                                  crossAxisSpacing: 1.0,
                                  children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((z) {
                                    return Container(
                                        alignment: Alignment.center,
                                        color: Colors.green,
                                        padding: EdgeInsets.all(1),
                                        child: Text((this.widget.smin.data[x * 9 + y].valuebox)[z].toString()));
                                  }).toList()));
                        }).toList()));
              }).toList())),
      );
    } catch (e) {
      print("Tt1app:error \n ${e.toString()}");
      return Container(
        child: Text(e.toString()),
      );
    }
  }
}
