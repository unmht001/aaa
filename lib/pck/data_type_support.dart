import 'dart:async';

import "dart:math";
// import 'package:aaa/pck/content_page.dart';
import 'package:aaa/pck/get_string.dart';
import 'package:aaa/pck/progress.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

String getUid(int length) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  int strlenght = length;
  String left = '';
  for (var i = 0; i < strlenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}

class Chain {
  Chain _father;
  Chain _son;
  Chain();
  Chain get father => _father;
  set father(Chain fa) {
    this._father = fa;
    fa._son = this;
  }

  Chain get first => _father == null ? this : _father.first;

  Chain get last => _son == null ? this : _son.son;
  Chain get son => _son;

  set son(Chain fa) {
    fa._father = this;
    this._son = fa;
  }

  Chain born() {
    if (this.son != null) {
      return this.son;
    } else {
      var _r = new Chain();
      _r._father = this;
      _r.father._son = _r;
      return _r;
    }
  }

  static Chain exchange(Chain ch1, Chain ch2) {
    //用 ch1 代替 ch2的位置;返回ch2;
    if (ch2._father != null) ch1.father = ch2.father;
    if (ch2._son != null) ch1.son = ch2.son;
    return ch1;
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

// 地址相关
  String bookBaseUrl;
  String menuUrl;
  String menuSoupTag;
  String menuPattan;
  get menudata => this.menuLsn.value;
  set menudata(value) => this.menudata.value = value;
  num selected;
  String siteCharset;
  String contentSoupTap;
  String contentPatten;
// 地址相关

  String uid;
  MyListener menuLsn;
  MyListener pageLsn;
  MyListener readingLsn;
  Map _mp;

  ProgressValue menuPv = new ProgressValue(0, 100);
  ProgressValue pagePv = new ProgressValue(0, 100);

  String toJson() {
    return json.encode(this._mp);
  }

  String toString() {
    return this._mp.toString();
  }

  continueReading() {}

  // getpagedata() async => await PageOp.getpagedata(this);
  // getmenudata() async => await PageOp.getmenudata(this);
  getpagedata() async => null;
  getmenudata() async => null;

  BookData(
      {this.id = 0,
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
      this.bookBaseUrl: "",
      this.menuUrl: "",
      this.menuSoupTag: "",
      this.menuPattan: "",
      this.selected: 0,
      this.siteCharset,
      this.contentSoupTap: "",
      this.contentPatten: ""}) {
    uid = getUid(10);
    pageLsn = ListenerBox.instance["page-" + uid];
    pageLsn.value = "等待页面载入....";
    menuLsn = ListenerBox.instance["menu-" + uid];
    menuLsn.value = "等待目录载入....";
    readingLsn = ListenerBox.instance["reading-" + uid];
    readingLsn.value = false;

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
      "yuepiao": this.yuepiao,
      "baseUrl": this.bookBaseUrl,
      "menuUrl": this.menuUrl,
      "menuSoupTag": this.menuSoupTag,
      "menuPattan": this.menuPattan,
      "menudata": this.menudata,
      "selected": this.selected,
      "siteCharset": this.siteCharset,
      "contentSoupTap": this.contentSoupTap,
      "contentPatten": this.contentPatten,
      "uid": this.uid
    };
  }
  BookData.create(Map mp)
      : this(
            id: mp["id"] ?? 0,
            pic: mp["pic"] ?? "图片",
            name: mp["name"] ?? "书名",
            author: mp["author"] ?? "作者名称",
            progress: mp["progress"] ?? "当前阅读进度",
            lastupdatetime: mp["lastupdatetime"] ?? "最新时间",
            lastupdatepagename: mp["lastupdatepagename"] ?? "最新章节名称",
            state: mp["state"] ?? "连载状态",
            fensizhi: mp["fensizhi"] ?? 0,
            fensidengji: mp["fensidengji"] ?? "见习",
            dingzhi: mp["dingzhi"] ?? false,
            gengxintixing: mp["gengxintixing"] ?? false,
            zidongdingyue: mp["zidongdingyue"] ?? false,
            shuyouquanxinxiaoxi: mp["shuyouquanxinxiaoxi"] ?? false,
            tuijianpiao: mp["tuijianpiao"] ?? 0,
            yuepiao: mp["yuepiao"] ?? 0,
            bookBaseUrl: mp["baseUrl"] ?? "",
            menuUrl: mp["menuUrl"] ?? "",
            menuSoupTag: mp["menuSoupTag"] ?? "",
            menuPattan: mp["menuPattan"] ?? "",
            selected: mp["selected"] ?? 0,
            siteCharset: mp["siteCharset"] ?? "",
            contentSoupTap: mp["contentSoupTap"] ?? "",
            contentPatten: mp["contentPatten"] ?? "");
}

class MyListener {
  dynamic _v = "初始";
  Function onGetter = () {};
  Function onSetter = () {};
  Function afterSetter = () {};
  bool inited = false;
  Map<String, Function> afterSetterList = {};

  // Function afterGetter=(){};
  get value {
    this.onGetter();
    return this.inited ? _v : null;
  }

  set value(var va) {
    this.onSetter();
    _v = va;
    this.inited = true;
    this.afterSetter();
  }
}

class ListenerBox {
  static final Map<String, MyListener> _box = {};
  static ListenerBox _instance;

  static ListenerBox get instance => _getInstance();
  factory ListenerBox() => _getInstance();
  ListenerBox._internal();

  MyListener operator [](String key) => key.isEmpty ? null : (_box[key] ?? (_box[key] = new MyListener()) ?? _box[key]);
  operator []=(String key, MyListener value) => key.isEmpty ? null : _box[key] ?? ((_box[key] = value) ?? _box[key]);

  static ListenerBox _getInstance() => _instance ?? ((_instance = new ListenerBox._internal()) ?? _instance);

  void el(String name) => ListenerBox.instance[name];
  MyListener getel(String name) => ListenerBox.instance[name];

  Iterable<MapEntry> get entries => _box.entries;
  Iterable get keys => _box.keys;
  int get length => _box.length;
  Iterable get values => _box.values;

  void addAll(Map other) => _box.addAll(other);
  void addEntries(Iterable<MapEntry> newEntries) => _box.addEntries(newEntries);
  void clear() => _box.clear();
  void updateAll(MyListener Function(Object key, Object value) update) => _box.updateAll(update);
  void removeWhere(bool Function(Object key, Object value) predicate) => _box.removeWhere(predicate);
  void forEach(void Function(Object key, Object value) f) => _box.forEach(f);

  bool containsKey(Object key) => _box.containsKey(key);
  bool containsValue(Object value) => _box.containsValue(value);
  bool isEmpty() => _box.isEmpty;
  bool isNotEmpty() => _box.isNotEmpty;

  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(Object key, Object value) f) => map(f);
  Map<RK, RV> cast<RK, RV>() => _box.cast();

  putIfAbsent(key, Function() ifAbsent) => _box.putIfAbsent(key, ifAbsent);
  remove(Object key) => _box.remove(key);
  update(key, MyListener Function(Object value) update, {Function() ifAbsent}) =>
      _box.update(key, update, ifAbsent: ifAbsent);

  @override
  noSuchMethod(Invocation mirror) => print('You tried to use a non-existent member:' + '${mirror.memberName}');
}

class Textsheet extends Chain {
  static const Color hColor = Colors.yellowAccent; //高亮颜色
  static const Color lColor = Colors.brown; //平常颜色
  Map data = {}; //数据集

  Textsheet() : super() {
    this.data["document"] = ""; //文字
    this.data["highlight"] = false;
  } //获取颜色
  Textsheet.fromMap(mp) : this.fromString(mp['document'], mp['highlight']); //获取文字

  Textsheet.fromString(String document, [bool highlight = false]) : super() {
    this.data["document"] = document ?? ""; //文字
    this.data["highlight"] = highlight;
  }

  Color get cl => this.data['highlight'] ? hColor : lColor;
  String get text => data["document"];
  @override
  Chain born() => Chain.exchange(new Textsheet(), super.born());

  changeHighlight() => this.data["highlight"] = !this.data["highlight"];
  highLight() => this.data["highlight"] = true;
  disHighLight() => this.data["highlight"] = false;

  static Textsheet getTextsheetChain(String text) {
    var s = text.split("\n");
    s.removeWhere((test) => test == "");
    if (s == null) {
      return null;
    } else {
      Textsheet ch1;
      Textsheet ch2;
      for (var item in s) {
        if (ch1 == null) {
          ch1 = Textsheet.fromString(item);
          ch2 = ch1;
        } else {
          ch2 = ch2.born();
          ch2.data["document"] = item;
        }
      }
      return ch1;
    }
  }
}

class NavData {
  String tt;
  IconData icon;
  NavData(String tt, IconData icon) {
    this.tt = tt;
    this.icon = icon;
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

mixin RefreshProviderSTF on StatefulWidget {
  final List<Function> _lf = [() {}];

  refresh() {
    _lf[0]();
  }
}
mixin RefreshProviderSate<T extends RefreshProviderSTF> on State<T> {
  final List<Function> _lf = [() {}];

  @override
  void initState() {
    super.initState();
    this.widget._lf[0] = () => setState(() {});
  }

  @override
  void dispose() {
    this.widget._lf[0] = () {};
    super.dispose();
  }

  @override
  setState(fn) => this.mounted ? super.setState(fn) : null;
}

//todo: 写一个dart 的 类似 python 的 async.event
class EventGun {
  bool isFired = false;
  bool isWaiting = false;

  Completer _completer = new Completer();

  Future waitFire() {
    if (this._completer.isCompleted) throw AppException("Gun is destroyed");
    if (this.isFired) throw AppException("Gun is fired");
    if (this.isWaiting) throw AppException("Gun is on some waiting ");
    this.isWaiting = true;
    return this._completer.future;
  }

  fire([arg]) {
    if (this._completer.isCompleted) throw AppException("Gun is destroyed");
    if (this.isFired) throw AppException("Gun is fired");
    if (!this.isWaiting) throw AppException("Gun is not waiting ");
    this.isWaiting = false;
    this.isFired = false;
    this._completer.complete(arg);
  }
}

class AppException implements Exception {
  final String message;
  const AppException([this.message]);
  String toString() => message ?? 'AppException';
}

class Chapter {
  String content = "等待加载中";
  Textsheet contentStart = new Textsheet();
  String chapterUrl;
  String chapterName;
  Chapter(this.chapterUrl,this.chapterName);
  getContent() {}
}

class BookDCS {}

class Book {
  String name;
  // String bookBaseUrl;
  num id;
  String author;
  String pic;
  String progress;
  String state;
  String lastupdatetime;
  String lastupdatepagename;
  String uid;
  // String site;

  List<Chapter> menu = [];

  Book(this.id, this.name, this.author, this.uid);
  Book.fromMap(Map bookdata) : this(bookdata["id"], bookdata["name"], bookdata["author"], bookdata["uid"]);
  getMenu() async
    =>await PageOp.getmenudata(this);

 
  BookState get getBookstate =>BookMark.bookState[this.uid];
  Site get getSite=>Bookcase.siteStore[ getBookstate.siteString];
  String get getMenuUrl=> getSite.siteBaseUrl+getSite.bookBaseUrls[uid]+getSite.menuUrl;
  double get getMenuPv=>getBookstate.menupv;
      setMenuPv()=>getBookstate.menupv
  
}

class Bookcase {
  static Map<String, Book> bookStore = {};
  static Map<String, Site> siteStore = {};

  Bookcase._internal();
  factory Bookcase() => _getInstance();

  static Bookcase _instance;
  static Bookcase _getInstance() => _instance ?? (_instance = Bookcase._internal());

  static init(List<Map> bookdata, Map sitedata, String siteUID) {
    _getInstance();
    BookMark.instance;
    for (var item in sitedata.keys) siteStore[item] = Site.fromMap(sitedata[item]);

    for (var item in bookdata) addBook(item);

    BookMark.currentBook = bookStore[bookdata[0]["uid"]];
  }

  static addBook(Map mp) {
    var _bk = Book.fromMap(mp);
    bookStore[mp["uid"]] = _bk;
    BookMark.bookState[_bk.uid] = BookState(_bk, mp["site"]);
    siteStore[mp["site"]].bookBaseUrls[mp["uid"]] = mp["bookBaseUrl"];
  }
}

class Site {
  String siteName;
  String siteBaseUrl;
  String siteUID;
  String menuUrl;
  String menuSoupTag;
  String menuPattan;
  String siteCharset;
  String contentSoupTap;
  String contentPatten;
  Site.fromMap(Map mp) {
    this.siteName = mp["siteName"];
    this.siteBaseUrl = mp["siteBaseUrl"];
    this.siteUID = mp["siteUID"];
    this.menuUrl = mp["menuUrl"];
    this.menuSoupTag = mp["menuSoupTag"];
    this.menuPattan = mp["menuPattan"];
    this.siteCharset = mp["siteCharset"];
    this.contentSoupTap = mp["contentSoupTap"];
    this.contentPatten = mp["contentPatten"];
  }
  Map<String, String> bookBaseUrls = {};
}

class BookState {
  String siteString;
  Book book;
  double menupv = 1.0;
  static double menuOffset;
  double pagepv = 1.0;
  static double contentOffset;
  static Chapter currentChapter;
  int currentChapterIndex;
  BookState(this.book, this.siteString);
}

class BookMark {
  static Book currentBook;

  static Map<String, BookState> bookState = {};

  BookMark._internal();
  factory BookMark() => _getInstance();

  static BookMark _instance;
  static BookMark _getInstance() => _instance ?? (_instance = BookMark._internal());
  static get instance => _getInstance();
  static MyListener menuLoadedLsn=MyListener();
  static MyListener pageLoadedLsn=MyListener();
}

// cMqCQqtlEQ
// BQHNPOKrzd
// JoGeGWNgUc
