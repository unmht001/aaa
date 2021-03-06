import 'package:flutter/material.dart';
// import 'package:sliver_glue/sliver_glue.dart';

final List<String> thistext = <String>['1', '2', "3", '1', '2', "3", '1', '2', "3"];

class Sdkcell {
  List valuebox = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int value;
  bool showvalue;
  int position;
  bool locked = false;

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
    print("${value == null} ${value != 0} ${valuebox.indexOf(v) == -1} ${1 >= v} ${v >= 9}");
    if (value == null || value != 0 || valuebox.indexOf(v) == -1 || 1 > v || v > 9) {
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
    // print("$geterr${value != 0}${valuebox.indexOf(pv) == -1}");
    if (geterr || value != 0 || valuebox.indexOf(pv) == -1) {
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
    var lr = pos2linerow(position);
    List<Sdkcell> ret = [];
    var _r;
    var _rr = [];
    print("$gc,$lr");
    for (var i = 0; i < 9; i++) {
      // print("i=$i");
      _r = gridindex2pos(gc[0], i);
      // print(_r);
      if (_rr.indexOf(_r) == -1 && _r != position) {
        ret.add(_sdkdt1[_r]);
        _rr.add(_r);
      }
      _r = lr[0] * 9 + i;
      // print(_r);

      if (_rr.indexOf(_r) == -1 && _r != position) {
        ret.add(_sdkdt1[_r]);
        _rr.add(_r);
      }
      _r = i * 9 + lr[1];
      // print(_r);
      if (_rr.indexOf(_r) == -1 && _r != position) {
        ret.add(_sdkdt1[_r]);
        _rr.add(_r);
      }
    }

    // print(ret.length);
    // print(_rr);

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

  savehis(his) {
    _his.add(his);
  }

  List gethis() {
    return _his.removeLast();
  }

  cellsetvalue(grid, index, value) {
    var pos = grid ~/ 3 * 27 + index ~/ 3 * 9 + grid % 3 * 3 + index % 3;
    // print("pps$pos");
    var _h = {
      "value": [0, 0],
      "killposible": [],
      "setposble": []
    };
    var cell = _sdkdt1[pos];
    if (cell.locked) {
      return;
    }
    if (! cell.setvalue(value)){
      return;
    }
    // assert(cell.setvalue(value), "position $pos set value $value error");
    _h["value"] = [pos, value];
    // print(pos2relevant(pos).toList());
    for (var item in pos2relevant(pos)) {
      if (item.value == 0) {
        if (item.killposible(value)) {
          _h["killposible"].add([item.position, value]);
        }
      } else {
        continue;
      }
    }
    savehis(_h);
    // _his.add(_h);
  }

  init({List lst,Map mp}){

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
    -1, //按扭状态
    0,//0正常状态，1错误状态

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
                                        child: this
                                                    .widget
                                                    .smin
                                                    .data[x ~/ 3 * 27 + y ~/ 3 * 9 + x % 3 * 3 + y % 3]
                                                    .value ==
                                                0
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
                                                      child: Text(this
                                                                  .widget
                                                                  .smin
                                                                  .data[x ~/ 3 * 27 + y ~/ 3 * 9 + x % 3 * 3 + y % 3]
                                                                  .valuebox
                                                                  .indexOf(z + 1) ==
                                                              -1
                                                          ? " "
                                                          : (z + 1).toString()));
                                                }).toList())
                                            : Text(this
                                                .widget
                                                .smin
                                                .data[x ~/ 3 * 27 + y ~/ 3 * 9 + x % 3 * 3 + y % 3]
                                                .value
                                                .toString())));
                              }).toList()));
                    }).toList()))),
        Container(
            width: 400,
            height: 40,
            child: Row(children: <Widget>[
              FlatButton(
                  child: Text("填入"),
                  color: msg[3] == 0 ? Colors.yellow : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (msg[3] == 0) {
                        msg[3] = -1;
                      } else {
                        msg[3] = 0;
                      }
                    });
                  }),
              FlatButton(
                  child: Text("清除"),
                  color: msg[3] == 1 ? Colors.yellow : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (msg[3] == 1) {
                        msg[3] = -1;
                      } else {
                        msg[3] = 1;
                      }
                    });
                  }),
              FlatButton(
                  child: Text("后退"),
                  color: msg[3] == 2 ? Colors.yellow : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (msg[3] == 2) {
                        msg[3] = -1;
                      } else {
                        msg[3] = 2;
                      }
                    });
                  }),
              FlatButton(
                  child: Text("试填"),
                  color: msg[3] == 3 ? Colors.yellow : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (msg[3] == 3) {
                        msg[3] = -1;
                      } else {
                        msg[3] = 3;
                      }
                    });
                  })
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
                        if (msg[1][0] != -1 && msg[1][1] != -1 && msg[3]==0) {
                          this.widget.smin.cellsetvalue(msg[1][0], msg[1][1], msg[2]);
                          setState(() {});
                        }
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
