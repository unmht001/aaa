import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytts8/mytts8.dart';

import 'pck/data_type_support.dart';
import 'pck/support/app_data.dart';
// import './pck/data_type_support.dart';
// import 'package:mytts8/mytts8.dart';

// bool initok = false;
// List<BookData> bdlist;

class Appdata {
  //Appdata define ----------
  Appdata._internal() {
    navs = [
      NavData("书架", Icons.book),
      NavData("来源", Icons.bookmark),
      NavData("正则", Icons.search),
      NavData("我", Icons.person)
    ];
    tts = Mytts8();
  }
  static Appdata _instance;
  static Appdata _getInstance() => _instance ?? (_instance = Appdata._internal());
  factory Appdata() => _getInstance();
  static Appdata get instance => _getInstance();
  //Appdata define over ------

  //data state fn
  static get data => App.instance.appState["data"] ?? (App.instance.appState["data"] = {});
  static get state => App.instance.appState["state"] ?? (App.instance.appState["state"] = {});
  static get fn => App.instance.appState["fn"] ?? (App.instance.appState["fn"] = {});

  static String get loadingtext => data["loadingtext"] ?? (data["loadingtext"] = "Loading");
  static set loadingtext(String v) => data["loadingtext"] = v;
  static double get width => data["width"] ?? (data["width"] = null);
  static set width(double v) => data["width"] = v;
  static double get height => data["height"] ?? (data["height"] = null);
  static set height(double v) => data["height"] = v;

  List get navs => data["navs"] ?? (data["navs"] = []);
  set navs(List v) => data["navs"] = v;

  List get bks => data["bks"] ?? (data["bks"] = []);
  set bks(List v) => data["bks"] = v;

  Mytts8 get tts => data["tts"] ?? (data["tts"] = new Mytts8());
  set tts(Mytts8 v) => data["tts"] = v;

  Map get sitedata => data["sitedata"] ?? (data["sitedata"] = {});
  set sitedata(Map v) => data["sitedata"] = v;

  PageController get pageController => data["pageController"] ?? (data["pageController"] = null);
  set pageController(PageController v) => data["pageController"] = v;

  //state
  static bool get isReadingMode => state["isReadingMode"] ?? (state["isReadingMode"] = false);
  static set isReadingMode(bool v) => state["isReadingMode"] = v;

  static bool get isAppOnBack => state["isAppOnBack"] ?? (state["isAppOnBack"] = false);
  static set isAppOnBack(bool v) => state["isAppOnBack"] = v;
}

Text stext(String s) =>
    Text(s, style: TextStyle(decoration: TextDecoration.none, fontSize: 13, color: Colors.grey[800]));



getDefault() async{

  String s=await rootBundle.loadString("lib/json/data.json");

  var j=json.decode(s);
  return j;
}
