import 'package:flutter/material.dart';
import 'dart:convert';

bool initok = false;
List<BookData> bdlist;
class NavData {
  String tt;
  IconData icon;
  NavData(String tt, IconData icon) {
    this.tt = tt;
    this.icon = icon;
  }
}

class BookData {
  int id = 0;
  String pic;
  String name;
  String author;
  String progress;
  String lastupdatetime;
  String lastupdatepagename;
  String state;

  double fensizhi;
  String fensidengji;
  bool dingzhi;
  bool gengxintixing;
  bool zidongdingyue;
  bool shuyouquanxinxiaoxi;
  int tuijianpiao;
  int yuepiao;

  Map _mp;

  String toJson() {
    return json.encode(this._mp);
  }
  String toString(){
    return this._mp.toString();
  }

  BookData({
    this.id = 0,
    this.pic: "图片",
    this.name: "书名",
    this.author: "作者名称",
    this.progress: "当前阅读进度",
    this.lastupdatetime: "最新时间",
    this.lastupdatepagename: "最新章节名称",
    this.state: "连载状态",
    this.fensizhi: 0,
    this.fensidengji: "见习",
    this.dingzhi: false,
    this.gengxintixing: false,
    this.zidongdingyue: false,
    this.shuyouquanxinxiaoxi: false,
    this.tuijianpiao: 0,
    this.yuepiao: 0,
  }) {
    this._mp = {
      "id": this.id,
      "pic": this.pic,
      "name": this.name,
      "author": this.author,
      "progress": this.progress,
      "lastupdatepagename": this.lastupdatepagename,
      "state": this.state,
      "fensizhi": this.fensizhi,
      "fensidengji": this.fensidengji,
      "gengxintixing": this.gengxintixing,
      "zidongdingyue": this.zidongdingyue,
      "shuyouquanxinxiaoxi": this.shuyouquanxinxiaoxi,
      "tuijianpiao": this.tuijianpiao,
      "yuepiao": this.yuepiao
    };
  }
  BookData.create(Map mp) {
    this.id = (mp["id"] == null) ? 0 : mp["id"];
    this.pic = (mp["pic"] == null) ? "图片" : mp["pic"];
    this.name = (mp["name"] == null) ? "书名" : mp["name"];
    this.author = (mp["author"] == null) ? "作者名称" : mp["author"];
    this.progress = (mp["progress"] == null) ? "当前阅读进度" : mp["progress"];
    this.lastupdatetime = (mp["lastupdatetime"] == null) ? "最新时间" : mp["lastupdatetime"];
    this.lastupdatepagename = (mp["lastupdatepagename"] == null) ? "最新章节名称" : mp["lastupdatepagename"];
    this.state = (mp["state"] == null) ? "连载状态" : mp["state"];
    this.fensizhi = (mp["fensizhi"] == null) ? 0 : mp["fensizhi"];
    this.fensidengji = (mp["fensidengji"] == null) ? "见习" : mp["fensidengji"];
    this.dingzhi = (mp["dingzhi"] == null) ? false : mp["dingzhi"];
    this.gengxintixing = (mp["gengxintixing"] == null) ? false : mp["gengxintixing"];
    this.zidongdingyue = (mp["zidongdingyue"] == null) ? false : mp["zidongdingyue"];
    this.shuyouquanxinxiaoxi = (mp["shuyouquanxinxiaoxi"] == null) ? false : mp["shuyouquanxinxiaoxi"];
    this.tuijianpiao = (mp["tuijianpiao"] == null) ? 0 : mp["tuijianpiao"];
    this.yuepiao = (mp["yuepiao"] == null) ? 0 : mp["yuepiao"];
    this._mp = {
      "id": this.id,
      "pic": this.pic,
      "name": this.name,
      "author": this.author,
      "progress": this.progress,
      "lastupdatepagename": this.lastupdatepagename,
      "state": this.state,
      "fensizhi": this.fensizhi,
      "fensidengji": this.fensidengji,
      "gengxintixing": this.gengxintixing,
      "zidongdingyue": this.zidongdingyue,
      "shuyouquanxinxiaoxi": this.shuyouquanxinxiaoxi,
      "tuijianpiao": this.tuijianpiao,
      "yuepiao": this.yuepiao
    };
  }
}

class Blockcelldata {
  String tt;
  int count;
  TextStyle ts2 = new TextStyle();
  Color tcolor;
  double ftsz;
  Blockcelldata(this.tt, this.count, {this.ftsz: 13, this.tcolor: Colors.white});
}

List<NavData> btms = [
  NavData("书架", Icons.book),
  NavData("精选", Icons.bookmark),
  NavData("发现", Icons.search),
  NavData("我", Icons.person)
];
List<BookData> bookdatapre = <BookData>[
  new BookData(
      id: 1,
      name: "归向",
      author: "核动力战列舰",
      state: "连载",
      progress: "已读到最新章节",
      gengxintixing: true,
      shuyouquanxinxiaoxi: true),
  new BookData(id: 2, name: "黎明之剑", author: "远瞳", state: "连载", progress: "已读到最新章节", gengxintixing: true),
  new BookData(id: 3, name: "还是地球人狠", author: "剑舞秀", state: "连载", progress: "已读到最新章节", gengxintixing: true),
  new BookData(id: 4, name: "万历驾到", author: "青橘白衫", state: "连载", progress: "已读到最新章节", gengxintixing: true),
  new BookData(id: 5, name: "死在火星上", author: "天瑞说符", state: "连载", progress: "已读到最新章节", gengxintixing: true),
];

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

bool checkdataok=false;
List sdkdata=[];
bool sdkdatainited=false;
var loadingtext="Loading...";