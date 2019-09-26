import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import 'pck/data_type_support.dart';
// import './pck/data_type_support.dart';
// import 'package:mytts8/mytts8.dart';

// bool initok = false;
// List<BookData> bdlist;

class Appdata {
  static Appdata _inst;
  static Appdata get instance => _inst == null ? _inst = new Appdata._internal() : _inst;
  factory Appdata() => instance;

  // List sdkdata = [];
  static String loadingtext = "Loading...";
  List navs;
  Mytts8 tts;
  List<Map<String, Object>> bks;
  Map<String, Map> sitedata;
  PageController  pageController;

  Appdata._internal() {
    navs = [
      NavData("书架", Icons.book),
      NavData("精选", Icons.bookmark),
      NavData("发现", Icons.search),
      NavData("我", Icons.person)
    ];

    tts = Mytts8();
    bks = [
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
    ];

    sitedata = {
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
      }
    };
  }
}

Text stext(String s) =>
    Text(s, style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: Colors.grey[800]));
