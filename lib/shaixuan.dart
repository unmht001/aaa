import 'package:flutter/material.dart';
import 'package:aaa/data.dart';
import './pck/data_type_support.dart';

List shaixuanState1 = <Blockcelldata>[
  Blockcelldata("连载", 0, tcolor: Colors.grey[300]),
  Blockcelldata("完本", 0, tcolor: Colors.grey[300]),
  Blockcelldata("未读过", 0, tcolor: Colors.grey[300]),
  Blockcelldata("已读完", 0, tcolor: Colors.grey[300]),
  Blockcelldata("超过50章未读", 0, tcolor: Colors.grey[300]),
  Blockcelldata("超过100章未读", 0, tcolor: Colors.grey[300]),
  Blockcelldata("10天内有更新", 0, tcolor: Colors.grey[300]),
  Blockcelldata("30天内有更新", 0, tcolor: Colors.grey[300]),
];
List shaixuanState2 = <Blockcelldata>[
  Blockcelldata("男生", 0, tcolor: Colors.grey[300]),
  Blockcelldata("女生", 0, tcolor: Colors.grey[300]),
  Blockcelldata("漫画", 0, tcolor: Colors.grey[300]),
  Blockcelldata("听书", 0, tcolor: Colors.grey[300]),
  Blockcelldata("出版", 0, tcolor: Colors.grey[300]),
  Blockcelldata(
    null,
    null,
  ),
  Blockcelldata("都市", 0, tcolor: Colors.grey[300]),
  Blockcelldata("历史", 0, tcolor: Colors.grey[300]),
  Blockcelldata("科幻", 0, tcolor: Colors.grey[300]),
  Blockcelldata("玄幻", 0, tcolor: Colors.grey[300]),
  Blockcelldata(
    null,
    null,
  ),
  Blockcelldata(
    null,
    null,
  ),
];

class Shaixuan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 50,
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  child: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text(
                "筛选",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 35,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                width: 50,
              ),
            ],
          ),
          getlabel("全部", "0", cl: Colors.red[100]),
          makeblock(shaixuanState1, "状态", 2),
          makeblock(shaixuanState2, "分类", 3),
        ],
      ),
    );
  }
}

Widget getlabel(String s1, String s2, {Color cl: Colors.white}) {
  if (s1 == null) {
    s1 = "";
  }
  if (s2 == "null") {
    s2 = "";
  }
  return Container(
    height: 40,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: cl,
      border: Border.all(width: 2, color: cl),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[stext(s1), stext(s2)],
    ),
  );
}

Widget makeblock(List<Blockcelldata> bd, String title, int grouped) {
  assert(grouped > 1);
  List<Blockcelldata> bd2;
  bd2 = bd.sublist(0);
  if (bd2.length % grouped > 0) {
    for (var i = bd2.length % grouped; i < grouped; i++) {
      bd2.add(Blockcelldata(
        null,
        null,
      ));
    }
  }
  return Column(
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: stext(title),
      ),
      Container(
        height: 220,
        padding: EdgeInsets.all(5),
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: () {
            List<Widget> rsc = <Widget>[];
            List<Widget> rs2;
            for (var i = 0; i < bd2.length ~/ grouped; i++) {
              rs2 = [];
              for (var j = 0; j < grouped - 1; j++) {
                rs2.add(
                  Expanded(
                    child: getlabel(bd2[i * grouped + j].tt, bd2[i * grouped + j].count.toString(),
                        cl: bd2[i * grouped + j].tcolor),
                  ),
                );
                rs2.add(
                  Container(
                    width: 15,
                  ),
                );
              }
              rs2.add(
                Expanded(
                  child: getlabel(bd2[(i + 1) * grouped - 1].tt, bd2[(i + 1) * grouped - 1].count.toString(),
                      cl: bd2[(i + 1) * grouped - 1].tcolor),
                ),
              );
              rsc.add(
                Row(
                  children: rs2,
                ),
              );
            }
            return rsc;
          }(),
        ),
      ),
    ],
  );
}
