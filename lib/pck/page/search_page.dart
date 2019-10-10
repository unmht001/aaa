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
    return Container( padding: EdgeInsets.all(30), alignment: Alignment.center,color: Colors.greenAccent[100], width: Appdata.width, height: Appdata.height-105, child: _SearchPage());
  }
}

class _SearchPage extends StatefulWidget {
  @override
  __SearchPageState createState() => __SearchPageState();
}

class __SearchPageState extends State<_SearchPage> {
  var l;
  var tc = TextEditingController(text: "地球");
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
          child: Row(
        children: <Widget>[
          FlatButton(
              onPressed: () async => update(await StateInit.readDataFromDefault()), child: Text("updataFromDefault:")),
          FlatButton(
              onPressed: () async => StateInit.saveDataToJson(await StateInit.readDataFromSetting()),
              child: Text("save to lcoal:")),
        ],
      )),
      Container(
          child: Row(children: <Widget>[
        Container(
            width: 250,
            child: TextField(
              controller: tc,
            )),
        Center(
            child: FlatButton(
                onPressed: () => Bookcase.siteStore["ywXSyXTKVO"]
                    .searchBook(tc.text)
                    .then((x) => setState(() => l = x is List ? x : x.toString())),
                child: Text("查找"))),
      ])),
      Container(
          width: 400,
          height: Appdata.height-300,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                  child: Container(
                      color: Colors.green,
                      child: (l ?? null) is List
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: (l as List)
                                  .map((x) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                                        Text(x[1].toString()),
                                        IconButton(
                                            onPressed: () {
                                              Bookcase.addBook(null,
                                                  book: Book(0, x[1], "未知", getUid(10)),
                                                  siteUid: "ywXSyXTKVO",
                                                  bookBaseUrl: x[0].toString().startsWith("/")
                                                      ? x[0].toString().substring(1)
                                                      : x[0]);
                                              BookMark.mainPageRefresher();
                                            },
                                            icon: Icon(Icons.add_box))
                                      ]))
                                  .toList())
                          : Text((l ?? "数据").toString(), softWrap: true)))))
    ]);
  }
}
