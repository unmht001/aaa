import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

getDefault() {
  return {
    "bookdata": [
      {"id": 1, "name": "剑来", "bookBaseUrl": "jianlai/", "author": "烽火戏诸侯", "uid": "RrnyYWAzzT", "site": "ywXSyXTKVO"},
      {
        "id": 2,
        "name": "还是地球人狠",
        "bookBaseUrl": "huanshidiqiurenhen/",
        "author": "不知道",
        "uid": "xAMgaXwYoL",
        "site": "ywXSyXTKVO"
      },
      {
        "id": 3,
        "name": "星辰之主",
        "bookBaseUrl": "xingchenzhizhu/",
        "author": "减肥专家",
        "uid": "dwmuEMQmPw",
        "site": "ywXSyXTKVO"
      },
      {
        "id": 4,
        "name": "黎明之剑",
        "bookBaseUrl": "limingzhijian/",
        "author": "大眼珠子",
        "uid": "BkXSEJlnaM",
        "site": "ywXSyXTKVO"
      },
      {"id": 5, "name": "第一序列", "bookBaseUrl": "dixulie/", "author": "不知道", "uid": "altdlfEtGl", "site": "ywXSyXTKVO"},
      {
        "id": 6,
        "name": "明朝败家子",
        "bookBaseUrl": "mingchaobaijiazi/",
        "author": "不知道",
        "uid": "LVHOSKvvCb",
        "site": "ywXSyXTKVO"
      },
      {
        "id": 7,
        "name": "归向",
        "bookBaseUrl": "cview/372/372593/",
        "author": "p皮划艇",
        "uid": "BQHNPOKrzd",
        "site": "cMqCQqtlEQ"
      },
    ],
    "sitedata": {
      "ywXSyXTKVO": {
        "siteUID": "ywXSyXTKVO",
        "siteName": "书迷楼",
        "siteBaseUrl": "http://www.shumil.co/",
        "menuUrl": "index.html",
        "menuSoupTag": "div.content",
        "menuPattan": "(<li.+?/li>)",
        "siteCharset": 'gbk',
        "contentPatten": "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        "contentSoupTap": '#content',
      },
      "cMqCQqtlEQ": {
        "siteUID": "cMqCQqtlEQ",
        "siteName": "啃文书库",
        "siteBaseUrl": "https://www.kenwen.com/",
        "menuUrl": "",
        "menuSoupTag": "div#list",
        "menuPattan": "(<dd>[\\s\\S]*?<dd>)",
        "siteCharset": 'utf8',
        "contentPatten": "[\\S\\s]*",
        "contentSoupTap": '#content',
      }
    }
  };
}

charsetS(Response rp, {String charset: "utf8"}) {
  if (charset == 'gbk')
    return Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
  else if (charset == 'utf8')
    return Utf8Decoder().convert(rp.data);
  else
    return 'unknow charset : $charset';
}

getmenudata(String bookUid) async {
  var setting = getDefault();

  var books = setting["bookdata"];
  var book;
  for (var item in books) {
    if (item["uid"] == bookUid) {
      book = item;
      break;
    }
  }
  var siteUid = book["site"];
  var site = setting['sitedata'][siteUid];
  var _ret;
  try {
    Dio dio = new Dio(
      BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
    );
    _ret = "等待目录载入....";

    var url = site["siteBaseUrl"] + book["bookBaseUrl"] + site["menuUrl"];

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      var soup = Beautifulsoup(charsetS(response, charset: "utf8").toString());
      var s1 = soup(site["menuSoupTag"]);
      var s2 = RegExp(site["menuPattan"], multiLine: true).allMatches(s1.outerHtml);
      var s12 = RegExp("<a[\\s\\S]+?href=\"(.+?)\">(.+?)</a>", multiLine: true);
      var _r;

      assert(s2 != null, "没有找到本书");
      assert(s2.length != 0, "章节获取失败");
      print(s2.length);
      print("sss:  ${ s2.toList()[0].group(1).toString()}") ;
      _ret = s2.toList()
          .map((vs) => [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
          .toList();
    } else
      _ret = "失败代码: ${response.statusCode}.";
  } catch (e) {
    _ret = e.toString();
  }
  print(_ret.length);
  return _ret;
}

main(List<String> args) {
  getmenudata("BQHNPOKrzd").then((x) => print(x));
}
