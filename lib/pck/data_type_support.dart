// import 'dart:async';

import "dart:math";
import 'package:aaa/pck/get_string.dart';
// import 'package:aaa/pck/map_support.dart';
import 'chain_support.dart';
// import 'package:aaa/pck/progress.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';

String getUid(int length) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  int strlenght = length;
  String left = '';
  for (var i = 0; i < strlenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
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

////////////////////////////////////////////////////////////////////////////////////////////////

class SectionSheet extends AbstractChain<SectionSheet> {
  static Color hColor = Colors.blueAccent[100]; //高亮颜色
  static Color lColor = Colors.amber[50]; //平常颜色

  GlobalKey sgk = new GlobalKey();

  SectionSheet _father;
  SectionSheet _son;

  double get height => (sgk?.currentContext?.size?.height) ?? 0.0;
  double get sumheight => height + (father == null ? 0.0 : father.sumheight);

  int index;
  // Map data = {}; //数据集
  String text;
  bool isHighlight = false;
  SectionSheet({this.text: "等待加载中", this.isHighlight: false});

  SectionSheet.fromMap(mp) : this.fromString(mp['text'], mp['highlight']); //获取文字
  SectionSheet.fromString(String text, [bool isHighlight = false]) : this(text: text, isHighlight: isHighlight);

  Color get cl => isHighlight ? hColor : lColor;
  changeHighlight() => isHighlight = !isHighlight;
  highLight() {
    print("height");
    SectionSheet _c = this;
    while (_c._father != null) {
      _c = _c._father;
      _c.isHighlight = false;
    }
    _c = this;
    while (_c._son != null) {
      _c = _c._son;
      _c.isHighlight = false;
    }

    this.isHighlight = true;
  }

  disHighLight() => isHighlight = false;

  static SectionSheet getSectionSheetChain(String text) {
    var s = text.split("\n");
    s.removeWhere((x) => x == "");
    if (s.isEmpty)
      return null;
    else {
      SectionSheet ch1 = SectionSheet.fromString(s[0]);
      SectionSheet ch2 = ch1;

      for (var item in s) {
        ch2.text = item;
        ch2 = ch2.born(SectionSheet());
      }
      ch2.father.son = null;
      return ch1;
    }
  }
}

class Chapter {
  String content = "等待加载中";
  SectionSheet baseSectionSheet = new SectionSheet();
  SectionSheet _contentStart;
  SectionSheet get contentStart {
    if (isloaded) {
      assert(_contentStart != null);
      return _contentStart;
    } else
      return baseSectionSheet;
  }

  set contentStart(SectionSheet sectionSheet) => _contentStart = sectionSheet;

  String chapterUrl;
  String chapterName;
  Book book;
  Chapter([this.chapterUrl = "", this.chapterName = "", this.book]);
  int index;
  bool isloaded = false;
  bool isloading = false;

  initContent() async {
    if (!isloading) {
      isloading = true;
      if (book != null) {
        content = await PageOp.getChapterData(this);
        contentStart = SectionSheet.getSectionSheetChain(content.toString());
        contentStart.highLight();
        isloaded = true;
        isloading = false;
        return true;
      } else
        isloading = false;
      return false;
    }
    return true;
  }
}

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

  toMap() {
    return {
      "id": this.id,
      "uid": this.uid,
      "author": this.author,
      "pic": this.pic,
      "progress": this.progress,
      "state": this.state,
      "lastupdatepagename": this.lastupdatepagename,
      "lastupdatetime": this.lastupdatetime
    };
  }

  toString() {
    return toMap().toString();
  }

  // String site;

  List<Chapter> menu = [];

  initMenu(List<List<String>> lm) {
    menu = [];
    var i = 0;

    for (var item in lm) {
      menu.add(Chapter(item[0], item[1], this));
      menu.last.index = i;
      i++;
    }
  }

  Book(this.id, this.name, this.author, this.uid) {
    menu.add(Chapter(null, null, this));
  }
  Book.fromMap(Map bookdata) : this(bookdata["id"], bookdata["name"], bookdata["author"], bookdata["uid"]);
  getMenu() async {
    var a = await PageOp.getmenudata(this);
    if (a is String)
      return false;
    else
      this.initMenu(a);
    getBookstate.isMenuLoaded = true;
    return true;
  }

  // getContent(Chapter chapter) async => await PageOp.getpagedata(this, chapter);
  BookState get getBookstate => BookMark.bookState[this.uid];
  Site get getSite => Bookcase.siteStore[getBookstate.siteString];
  String get getMenuUrl => getSite.siteBaseUrl + getSite.bookBaseUrls[uid] + getSite.menuUrl;
  double get getMenuPv => getBookstate.menupv;
  // setMenuPv()=>getBookstate.menupv

}

class BookState {
  String siteString;
  Book book;
  double menupv = 1.0;
  static double menuOffset;
  double pagepv = 1.0;
  static double contentOffset;
  Chapter currentChapter;

  BookState(this.book, this.siteString);
  bool isreading = false;
  bool isMenuLoaded = false;
}

class Bookcase {
  static Map<String, Book> bookStore = {};
  static Map<String, Site> siteStore = {};

  Bookcase._internal();
  factory Bookcase() => _getInstance();

  static Bookcase _instance;
  static Bookcase _getInstance() => _instance ?? (_instance = Bookcase._internal());

  static init(List bookdata, Map sitedata, String siteUID) {
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
  toMap() => {
        "siteName": this.siteName,
        "siteUID": this.siteUID,
        "siteBaseUrl": this.siteBaseUrl,
        "menuUrl": this.menuUrl,
        "menuSoupTag": this.menuSoupTag,
        "menuPattan": this.menuPattan,
        "siteCharset": this.siteCharset,
        "contentSoupTap": this.contentSoupTap,
        "contentPatten": this.contentPatten,
        "bookBaseUrls": this.bookBaseUrls
      };
  toString() => toMap.toString();

  Map<String, String> bookBaseUrls = {};
}

class BookMark {
  static Function currentBookAfterSetForMenu;
  static Function currentBookAfterSetForPage;
  static Book _currentBook;
  static Book get currentBook => _currentBook;
  static set currentBook(Book bk) {
    _currentBook = bk;
    (currentBookAfterSetForMenu ?? () {})();
    (currentBookAfterSetForPage ?? () {})();
  }

  // static Function menuPageRefresher;

  static Map<String, BookState> bookState = {};

  BookMark._internal();
  factory BookMark() => _getInstance();

  static BookMark _instance;
  static BookMark _getInstance() => _instance ?? (_instance = BookMark._internal());
  static get instance => _getInstance();
  static MyListener menuLoadedLsn = MyListener();
  static MyListener pageLoadedLsn = MyListener();
}


// 
// 
