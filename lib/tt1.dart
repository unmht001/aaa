import 'package:flutter/material.dart';
// import 'package:sliver_glue/sliver_glue.dart';

final List<String> thistext = <String>['1', '2', "3", '1', '2', "3", '1', '2', "3"];

class Sdkcell {
  List valuebox = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int value;
  bool showvalue;
  int position;
  bool locked=false;

  int get sline => position ~/ 9;
  int get srow => position % 9;
  int get sgrid => (position ~/ 27) * 3 + (position % 9) ~/ 3;
  int get sgindex => ((position ~/ 9) % 3) * 3 + position % 3;
  bool get geterr => valuebox == null || valuebox.length == 0;

  void seterr() {
    valuebox = null;
    value = 0;
  }

  bool setvalue(int v) {
    if (value == null || value == 0 || valuebox.indexOf(v) == -1 || 1 >= v || v >= 9) {
      return false;
    } else {
      valuebox = [v];
      value = v;
      return true;
    }
  }

  clearcell() {
    valuebox = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    value = 0;
    showvalue = false;
  }

  bool killposible(int pv) {
    if (!geterr || value != 0 || valuebox.indexOf(pv) == -1) {
      return false;
    } else {
      valuebox.remove(pv);
      return true;
    }
  }

  bool checkcell() {
    return !geterr && (value == 0 || (value >= 1 && value <= 9 && valuebox[0] == value));
  }

  Sdkcell(this.position, [int vl = 0]) : assert(position != null && position > -1 && position < 81) {
    clearcell();
    if (vl != 0) {
      setvalue(vl);
    }
  }
}

class Sdkmain {
  List<Sdkcell> _sdkdt1 = [];
  List _his = [];
  List get data => _sdkdt1;

  int linerow2pos(int x, int y) => x * 9 + y;
  int gridindex2pos(int x, int y) => (x ~/ 3) * 27 + (x % 3) * 3 + (y ~/ 3) * 9 + y % 3;

  List pos2linerow(int position) => [position ~/ 9, position % 9];
  List pos2gridindex(int position) =>
      [(position ~/ 27) * 3 + (position % 9) ~/ 3, ((position ~/ 9) % 3) * 3 + position % 3];
  List<Sdkcell> pos2relevant(int position) {
    var gc = pos2gridindex(position);
    var ret = [];
    var _r;
    for (var i = 0; i < 9; i++) {
      if (gc[1] != i) {
        _r = gridindex2pos(gc[0], i);
        if (ret.indexOf(_r) == -1) {
          ret.add(_sdkdt1[_r]);
        }
      }
    }
    return ret;
  }

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

  savehis(List his) {
    _his.add(his);
  }

  List gethis() {
    return _his.removeLast();
  }

  cellsetvalue(pos, value) {
    var _h = {
      "value": [0, 0],
      "killposible": [],
      "setposble": []
    };
    var cell = _sdkdt1[pos];
    if (cell.locked){
      return;
    }
    assert(cell.setvalue(value), "position $pos set value $value error");
    _h["value"] = [pos, value];
    for (var item in pos2relevant(pos)) {
      if (item.value == 0) {
        if (item.killposible(value)) {
          _h["killposible"].add([item.position, value]);
        }
      } else {
        continue;
      }
    }
    _his.add(_h);
  }

  Sdkmain() {
    for (var i = 0; i < 81; i++) {
      _sdkdt1.add(Sdkcell(i));
    }
  }
}

class SdkGrid extends StatefulWidget {
  final List data = [[], [], []];
  final Sdkmain smin = new Sdkmain();
  final colors = {
    "c1": Colors.white,
    "c2": Colors.pink[200],
    "c3": Colors.yellow[900],
    "c4": Colors.yellow[300],
    "c5": Colors.grey[100],
    "c6": Colors.orange,
    'c7': Colors.green,
    'c8': Colors.grey
  };
  SdkGrid() {
    for (var i = 0; i < 81; i++) {}
  }

  @override
  _SdkGridState createState() => _SdkGridState();
}

class _SdkGridState extends State<SdkGrid> {
  final List msg = [
    "show someting",
    [-1, -1], //坐标信息
    1, //上次选中的数字
  ];

  Color getcl(x, y) {
    if (msg[1][0] < 0 || msg[1][1] < 0) {
      return this.widget.colors["c1"]; //初始化颜色
    } else if (msg[1][0] == x && msg[1][1] == y) {
      return this.widget.colors["c2"]; //
    } else if ((msg[1][0] % 3 == x % 3 && msg[1][1] % 3 == y % 3) ||
        (msg[1][0] ~/ 3 == x ~/ 3 && msg[1][1] ~/ 3 == y ~/ 3)) {
      return this.widget.colors["c3"];
    } else if (msg[1][0] == x) {
      return this.widget.colors["c4"];
    } else {
      return this.widget.colors["c5"]; //点了以后回复的颜色
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Container(),
        Container(
            width: 400,
            height: 400,
            child: Container(
                //大格子
                color: Colors.tealAccent,
                alignment: Alignment.center,
                child: GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((x) {
                      return Container(
                          //中格子
                          alignment: Alignment.center,
                          color: Colors.red,
                          padding: EdgeInsets.all(1),
                          child: GridView.count(
                              padding: EdgeInsets.zero,
                              crossAxisCount: 3,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 1.0,
                              children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((y) {
                                var _c1 = getcl(x, y);
                                return Container(
                                    //小格子CELL
                                    alignment: Alignment.center,
                                    color: Colors.blue,
                                    padding: EdgeInsets.all(1),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            msg[1] = [x, y];
                                            msg[0] = msg[1].toString();
                                          });
                                        },
                                        // onTapDown: (dt){},
                                        child: this.widget.smin.data[x * 9 + y].value == 0
                                            ? GridView.count(
                                                padding: EdgeInsets.zero,
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 1.0,
                                                crossAxisSpacing: 1.0,
                                                children: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((z) {
                                                  return Container(
                                                      alignment: Alignment.center,
                                                      color: _c1,
                                                      padding: EdgeInsets.all(1),
                                                      child: Text(
                                                          this.widget.smin.data[x * 9 + y].valuebox.indexOf(z+1) == -1
                                                              ? " "
                                                              : (z+1).toString()));
                                                }).toList())
                                            : Text(this.widget.smin.data[x * 9 + y].value.toString())));
                              }).toList()));
                    }).toList()))),
        Container(
            width: 400,
            height: 40,
            child: Row(children: <Widget>[
              FlatButton(child: Text("填入"), onPressed: () {
                var _ppp=msg[1][0] *9+  msg[1][1] ;
                if( msg[1][0] != -1 && msg[1][1] != -1){
                  this.widget.smin.cellsetvalue(_ppp, msg[2]);
                  setState(() {});
                }

              }),
              FlatButton(child: Text("清除"), onPressed: () {}),
              FlatButton(child: Text("后退"), onPressed: () {}),
              FlatButton(child: Text("试填"), onPressed: () {})
            ])),
        Container(
            width: 396,
            height: 44,
            color: Colors.red,
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 9,
              shrinkWrap: true,
              children: [1, 2, 3, 4, 5, 6, 7, 8, 9].map((z) {
                return FlatButton(
                    color: msg[2] == z ? (this.widget.colors['c7']) : this.widget.colors["c6"],
                    child: Text(z.toString()),
                    onPressed: () {
                      setState(() {
                        msg[2] = z;
                      });
                    });
              }).toList(),
            ))
      ]);
    } catch (e) {
      print("Tt1app:error \n ${e.toString()}");
      return Container(child: Text(e.toString()));
    }
  }
}
