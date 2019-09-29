import 'dart:convert';
import 'dart:io';

import 'package:aaa/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

class RegexpTestPageData {
  static double p1 = 20;
  static double w1 = Appdata.width - p1 * 2;
  static double w2 = w1;
  static double w3 = w1 - 100;
  static double h1 = Appdata.height / 2 - p1 - h3 - 45 - h3 * 0.5;
  static double h2 = h1;
  static double h3 = 50;

  static String _url = "https://www.kenwen.com/cview/372/372593/";
  static String _regtext = "";
  static String _content = "";
  static String _result = "";

  static bool first = false;
  static num groupNum = 0;

  static String get url => _url;
  static Function(String) onUrlChange;
  static set url(data) {
    onUrlChange(data);
    _url = data;
  }

  static String get regtext => _regtext;
  static Function(String) onregtextChange;
  static set regtext(data) {
    _regtext = data;
    onregtextChange(data);
  }

  static String get content => _content;
  static Function(String) oncontentChange;
  static set content(data) {
    _content = data;
    oncontentChange(data);
  }

  static String get result => _result;
  static Function(String) onresultChange;
  static set result(data) {
    _result = data;
    onresultChange(data);
  }

  static charsetS(Response rp, {String charset: "utf8"}) {
    if (charset == 'gbk')
      return Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
    else if (charset == 'utf8')
      return Utf8Decoder().convert(rp.data);
    else
      return 'unknow charset : $charset';
  }

  static String charset = "utf8";
  static getTestPage(String url, [String charSet]) async {
    var r;
    try {
      Dio dio = new Dio(BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes));

      var response = await dio.get(url);
      if (response.statusCode == 200)
        r = charsetS(response, charset: charSet ?? charset).toString();
      else
        r = "Request failed with status: ${response.statusCode}.";
    } catch (e) {
      r = "getpagedta error" + e.toString();
    }
    return r;
  }

  static regExp(String patten, String text) {
    try {
      var aa;
      if (first) {
        aa = RegExp(patten, multiLine: true).firstMatch(text);
        var s = "";
        for (var i = 0; i <= aa.groupCount; i++) {
          if (i >= RegexpTestPageData.groupNum) s += "(${aa.group(i).toString()})";
        }
        return [s];
      } else {
        aa = RegExp(patten, multiLine: true).allMatches(text);
        if (aa.length == 0)
          return [];
        else
          print(aa.length);

        return aa.toList().map((x) {
          // print(x.toString());
          var s = "";
          for (var i = 0; i <= x.groupCount; i++) {
            if (i >= RegexpTestPageData.groupNum) s += "(${x.group(i).toString()})";
          }
          print(s);
          return s;
        }).toList();
      }
    } catch (e) {
      return [];
    }
  }
}

class RegexpTestPage extends StatefulWidget {
  @override
  _RegexpTestPageState createState() => _RegexpTestPageState();
}

class _RegexpTestPageState extends State<RegexpTestPage> {
  TextEditingController t1;
  TextEditingController t2;
  TextEditingController t3;
  TextEditingController t4;
  TextEditingController t5;
  @override
  void initState() {
    super.initState();
    t1 = TextEditingController(text: RegexpTestPageData.url);
    RegexpTestPageData.onUrlChange = (data) => t1.text = data.toString();
    t2 = TextEditingController(text: RegexpTestPageData.regtext);
    RegexpTestPageData.onregtextChange = (data) => t2.text = data.toString();
    t3 = TextEditingController(text: RegexpTestPageData.content);
    RegexpTestPageData.oncontentChange = (data) => t3.text = data.toString();
    t4 = TextEditingController(text: RegexpTestPageData.result);
    RegexpTestPageData.onresultChange = (data) => t4.text = data.toString();
    t5 = TextEditingController(text: RegexpTestPageData.groupNum.toString());
  }

  @override
  void dispose() {
    RegexpTestPageData.onUrlChange = (data) {};
    t1.dispose();
    RegexpTestPageData.onregtextChange = (data) {};
    t2.dispose();
    RegexpTestPageData.oncontentChange = (data) {};
    t3.dispose();
    RegexpTestPageData.onresultChange = (data) {};
    t4.dispose();
    t5.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        width: Appdata.width,
        height: Appdata.height - 90,
        padding: EdgeInsets.all(RegexpTestPageData.p1),
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.yellow[100],
                height: RegexpTestPageData.h3,
                child: Tooltip(
                    child: TextField(controller: t1, onChanged: (data) => RegexpTestPageData._url = data.toString()),
                    message: "URL")),
            Container(
                color: Colors.yellow[100],
                height: RegexpTestPageData.h1,
                child: Tooltip(
                    child: TextField(
                      maxLines: 9999,
                      controller: t3,
                      readOnly: true,
                    ),
                    message: "网页内容")),
            Container(
                color: Colors.green[100],
                height: RegexpTestPageData.h3,
                child: ListView(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: RegexpTestPageData.first,
                        onChanged: (v) => setState(() {
                          RegexpTestPageData.first = !RegexpTestPageData.first;
                          print(RegexpTestPageData.first);
                        }),
                      ),
                      Container(
                        height: RegexpTestPageData.h3,
                        width: 20,
                        child: TextField(
                          onChanged: (String x) => RegexpTestPageData.groupNum = int.parse(x),
                          controller: t5,
                        ),
                      ),
                      Container(
                        height: RegexpTestPageData.h3,
                        width: RegexpTestPageData.w3 - 20,
                        child: Tooltip(
                            child: TextField(
                              controller: t2,
                              onChanged: (data) => RegexpTestPageData._regtext = data.toString(),
                            ),
                            message: "REGEXP"),
                      )
                    ],
                  )
                ])),
            Container(
                color: Colors.blue[100],
                height: RegexpTestPageData.h3,
                child: Row(children: <Widget>[
                  FlatButton(
                      color: Colors.yellow[100],
                      onPressed: () {
                        RegexpTestPageData.getTestPage(RegexpTestPageData.url).then((x) {
                          setState(() {
                            t3.text = x.toString();
                          });
                        });
                      },
                      child: Text("获取网页内容")),
                  FlatButton(
                      color: Colors.green[100],
                      onPressed: () {
                        if (t2.text != "" && t2.text != "") {
                          List aa = RegexpTestPageData.regExp(t2.text, t3.text);
                          var s = aa.join("\n");
                          setState(() {
                            t4.text = s;
                          });
                        }
                      },
                      child: Text("测试正则")),
                  IconButton(
                      color: Colors.red[300],
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                      )),
                  IconButton(
                      color: Colors.red[300],
                      onPressed: () {},
                      icon: Icon(
                        Icons.save,
                      )),
                ])),
            Container(
                color: Colors.green[100],
                height: RegexpTestPageData.h1,
                child: Tooltip(
                    child: TextField(
                      maxLines: 9999,
                      controller: t4,
                      readOnly: true,
                    ),
                    message: "正则内容")),
          ],
        ),
      )
    ]);
  }
}
