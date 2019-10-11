// import 'dart:io';

import 'package:aaa/data_type.dart';
import 'package:aaa/init_fun.dart';
import 'package:aaa/pck/support/get_uid.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:gbk2utf8/gbk2utf8.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        alignment: Alignment.center,
        color: Colors.greenAccent[100],
        width: Appdata.width,
        height: Appdata.height - 105,
        child: _SearchPage());
  }
}

class _SearchPage extends StatefulWidget {
  @override
  __SearchPageState createState() => __SearchPageState();
}

class __SearchPageState extends State<_SearchPage> {
  String l = "";
  List _r = [];
  var tc = TextEditingController(text: "地球");
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
          child: Row(children: <Widget>[
        FlatButton(onPressed: () async => loadDefault().then((x) => BookMark.mainPageRefresher()), child: Text("加载默认")),
        FlatButton(onPressed: () async => saveData(), child: Text("保存设置"))
      ])),
      Container(
          child: Row(children: <Widget>[
        Container(width: 200, child: TextField(controller: tc)),
        Center(
            child: FlatButton(
                child: Text("查找"),
                onPressed: () async {
                  _r=[];
                  for (var item in Bookcase.siteStore.values.toList()) {
                    var a = await item.searchBook(tc.text);
                    if (a is List)
                      for (var i2 in a) _r.add([i2[0], i2[1], item]);
                    else
                      l += a.toString();
                  }
                  setState(() {});
                }))
      ])),
      Container(
          width: 400,
          height: Appdata.height - 300,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                  child: Container(
                      color: Colors.green,
                      child: _r.isNotEmpty ? listToView(_r, 400) : Text((l ?? "数据").toString(), softWrap: true)))))
    ]);
  }

  Widget listToView(List lst, double width) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: (lst
                ?.map((x) => Container(
                    width: width - 100,
                    color: Colors.pink[50],
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Text((x[2] as Site).siteName.toString(), softWrap: true),
                      Text(x[1].toString(), softWrap: true),
                      IconButton(
                          onPressed: () => Future(Bookcase.addBook(null,
                                  book: Book(0, x[1], "未知", getUid(10)),
                                  siteUid: (x[2] as Site).siteName,
                                  bookBaseUrl: x[0].toString().startsWith("/") ? x[0].toString().substring(1) : x[0]))
                              .then((x) => BookMark.mainPageRefresher()),
                          icon: Icon(Icons.add_box))
                    ])))
                ?.toList() ??
            [Container()]));
  }
}
