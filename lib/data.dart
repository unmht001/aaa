import 'package:flutter/material.dart';
import './pck/data_type_support.dart';
import 'package:mytts8/mytts8.dart';

bool initok = false;
List<BookData> bdlist;

List<NavData> btms = [
  NavData("书架", Icons.book),
  NavData("精选", Icons.bookmark),
  NavData("发现", Icons.search),
  NavData("我", Icons.person)
];
// List<BookData> bookdatapre = <BookData>[
//   new BookData(
//     id: 1,
//     name: "归向",
//     author: "核动力战列舰",
//     state: "连载",
//     progress: "已读到最新章节",
//     gengxintixing: true,
//     shuyouquanxinxiaoxi: true,
//   ),
//   new BookData(
//     id: 2,
//     name: "黎明之剑",
//     author: "远瞳",
//     state: "连载",
//     progress: "已读到最新章节",
//     gengxintixing: true,
//   ),
//   new BookData(
//     id: 3,
//     name: "还是地球人狠",
//     author: "剑舞秀",
//     state: "连载",
//     progress: "已读到最新章节",
//     gengxintixing: true,
//   ),
//   new BookData(
//     id: 4,
//     name: "万历驾到",
//     author: "青橘白衫",
//     state: "连载",
//     progress: "已读到最新章节",
//     gengxintixing: true,
//   ),
//   new BookData(
//     id: 5,
//     name: "死在火星上",
//     author: "天瑞说符",
//     state: "连载",
//     progress: "已读到最新章节",
//     gengxintixing: true,
//   ),
// ];

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
Text stext(String s) {
  return Text(
    s,
    style: TextStyle(
      decoration: TextDecoration.none,
      fontSize: 13,
      color: Colors.grey[800],
    ),
  );
}

bool checkdataok = false;
List sdkdata = [];
bool sdkdatainited = false;
var loadingtext = "Loading...";

class StateInit {
  static StateInit _instance;
  static StateInit get instance => _instance ?? new StateInit._internal();
  factory StateInit() => _instance ?? new StateInit._internal();
  StateInit._internal() {
    if (StateInit._instance == null) {
      var bk1 = BookData(
        id: 1,
        name: "剑来",
        baseUrl: "http://www.shumil.co/jianlai/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
        author: "烽火戏诸侯",
        state: "连载",
        progress: "已读到最新章节",
        gengxintixing: true,
        shuyouquanxinxiaoxi: true,
      );
      var bk2 = BookData(
        id: 2,
        name: "还是地球人狠",
        baseUrl: "http://www.shumil.co/huanshidiqiurenhen/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
        author: "不知道",
        state: "连载",
        progress: "已读到最新章节",
        gengxintixing: true,
        shuyouquanxinxiaoxi: true,
      );
      var bk3 = BookData(
        id: 3,
        name: "星辰之主",
        baseUrl: "http://www.shumil.co/xingchenzhizhu/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
        author: "减肥专家",
        state: "连载",
        progress: "已读到最新章节",
        gengxintixing: true,
        shuyouquanxinxiaoxi: true,
      );
      var bk4 = BookData(
        id: 4,
        name: "黎明之剑",
        baseUrl: "http://www.shumil.co/limingzhijian/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
        author: "大眼珠子",
        state: "连载",
        progress: "已读到最新章节",
        gengxintixing: true,
        shuyouquanxinxiaoxi: true,
      );
      var bk5 = BookData(
        id: 5,
        name: "第一序列",
        baseUrl: "http://www.shumil.co/dixulie/",
        menuUrl: "index.html",
        menuSoupTag: "div.content",
        menuPattan: "(<li.+?/li>)",
        siteCharset: 'gbk',
        contentPatten: "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
        contentSoupTap: '#content',
        author: "不知道",
        state: "连载",
        progress: "已读到最新章节",
        gengxintixing: true,
        shuyouquanxinxiaoxi: true,
      );
      ListenerBox.instance['bk'].value = bk1;
      ListenerBox.instance['bks'].value = [bk1, bk2, bk3, bk4, bk5];
      ListenerBox.instance['isreading'].value = false;
      ListenerBox.instance['cpLoaded'].value = false;
      ListenerBox.instance['tts'].value = Mytts8();
      ListenerBox.instance['speechrate'].value = 1.5;
      ListenerBox.instance['pitch'].value = 0.8;
    }
  }
}
