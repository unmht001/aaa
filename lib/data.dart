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
  List bks;
  Map sitedata;
  PageController pageController;
  static double width;
  static double height;

  Appdata._internal() {
    navs = [
      NavData("书架", Icons.book),
      NavData("来源", Icons.bookmark),
      NavData("正则", Icons.search),
      NavData("我", Icons.person)
    ];

    tts = Mytts8();
  }
}

Text stext(String s) =>
    Text(s, style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: Colors.grey[800]));

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
      {
        "id": 5,
        "name": "无限猎场",
        "bookBaseUrl": "cview/100/100587/",
        "author": "不知道",
        "uid": "JoGeGWNgUc",
        "site": "cMqCQqtlEQ"
      },
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
        "author": "皮划艇",
        "uid": "BQHNPOKrzd",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 8,
        "name": "修真聊天群",
        "bookBaseUrl": "cview/7/7760/",
        "author": "圣骑士",
        "uid": "AjgdTucRmk",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 9,
        "name": "大明之五好青年",
        "bookBaseUrl": "cview/402/402964/",
        "author": "未知",
        "uid": "WRiNTBTFYn",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 10,
        "name": "深空之流浪舰队",
        "bookBaseUrl": "cview/387/387491/",
        "author": "未知",
        "uid": "TiEqeFhrwd",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 11,
        "name": "工业心脏",
        "bookBaseUrl": "cview/439/439940/",
        "author": "未知",
        "uid": "AczsBAbGNo",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 12,
        "name": "玩家凶猛",
        "bookBaseUrl": "cview/425/425523/",
        "author": "未知",
        "uid": "pUIupDlLUS",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 13,
        "name": "我把系统安排了",
        "bookBaseUrl": "cview/434/434489/",
        "author": "未知",
        "uid": "etDoiqEfeH",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 14,
        "name": "会穿越的流浪地球",
        "bookBaseUrl": "cview/396/396929/",
        "author": "未知",
        "uid": "PiQHbuxGly",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 15,
        "name": "为师有个新任务",
        "bookBaseUrl": "cview/434/434742/",
        "author": "未知",
        "uid": "ciwlgLgyMJ",
        "site": "cMqCQqtlEQ"
      },
      {
        "id": 16,
        "name": "幻想世界大穿越",
        "bookBaseUrl": "cview/7/7460/",
        "author": "未知",
        "uid": "FqXawmixux",
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
        "menuPattan": "<dd>([\\s\\S]+?)</dd>",
        "siteCharset": 'utf8',
        "contentPatten": "([\\S\\s]*)",
        "contentSoupTap": '#content',
      }
    }
  };
}
//
//
//
//
//
//
//
//
//
//
