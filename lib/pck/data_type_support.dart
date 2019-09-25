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

abstract class AbstractBaseChain<T> {
  T _father;
  T _son;
  T get father;
  set father(T father);
  T get son;
  set son(T son);
}

abstract class AbstractChain<T extends AbstractBaseChain> extends AbstractBaseChain {
  @override
  T get father => _father;
  @override
  T get son => _son;

  @override
  set father(father) {
    this._father = father;
    father._son = this;
  }

  @override
  set son(son) {
    if (son != null) son._father = this;
    this._son = son;
  }

  T get first => _father == null ? this : _father.first;
  T get last => _son == null ? this : _son.son;

  int get genFather => _father == null ? 0 : _father.genFather - 1;
  int get genChildren => _son == null ? 0 : _son.genChildren + 1;

  T exchange(T ch1, T ch2) {
    if (ch2._father != null) ch1.father = ch2.father;
    if (ch2._son != null) ch1.son = ch2.son;
    return ch1;
  }

  T born(T child) {
    if (this.son != null) {
      return this.son;
    } else {
      child.father = this;
      return child;
    }
  }

  T getGen(int x) {
    if (x == 0)
      return this as T;
    else if (x < 0 && this._father != null)
      return _father.getGen(x + 1);
    else if (x > 0 && this._son != null)
      return _son.getGen(x - 1);
    else
      return null;
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

class StateStore {
  bool canSet = true;
  bool doing = false;
  List<Future> doingSetAfter = [];

  List<Function> action = [];
}

mixin RefreshProviderSTF on StatefulWidget {
  final List<Function> _lf = [() {}];
  final StateStore state = new StateStore();
  refresh() {
    _lf[0]();
  }
}
mixin RefreshProviderState<T extends RefreshProviderSTF> on State<T> {
  final List<Function> _lf = [() {}];
  static int _count = 0;
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

  _setState() async {
    print("start setState ${this.widget.state.action.length} ");
    try {
      RefreshProviderState._count += 1;
      print("${RefreshProviderState._count.toString()}:${this.widget.state.action.length}:${this.widget.state.doing}");
    } catch (e) {
      print(e);
    }

    while (this.widget.state.action.isNotEmpty) {
      this.widget.state.doing = true;

      await Future.value((this.widget.state.action.removeAt(0))());
      this.widget.state.doing = false;
    }

    if (this.widget.state.action.isEmpty && !this.widget.state.doing && this.mounted) super.setState(() {});
  }

  @override
  setState(fn) {
    this.widget.state.action.add(fn);
    if (this.widget.state.canSet) {
      this.widget.state.canSet = false;
      _setState().then((x) {
        this.widget.state.canSet = true;
      });
    } else {
      print("已经开始setState,此次加入等待");
    }
  }
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

////////////////////////////////////////////////////////////////////////////////////////////////

class SectionSheet extends AbstractChain<SectionSheet> {
  static Color hColor = Colors.blueAccent[100]; //高亮颜色
  static Color lColor = Colors.amber[50]; //平常颜色

  GlobalKey sgk = new GlobalKey();

  double get height => (sgk?.currentContext?.size?.height) ?? 0.0;
  double get sumheight => height + ( father==null ? 0.0: father.sumheight);

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

// cMqCQqtlEQ
// BQHNPOKrzd
// JoGeGWNgUc
