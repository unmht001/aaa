import 'package:flutter/material.dart';

import 'init_fun.dart';
import 'data.dart';

import 'pck/data_type_support.dart';
import 'pck/content_page.dart';
import 'pck/menu_page.dart';
import 'pck/main_page.dart';
import 'pck/event_gun.dart';

EventGun gun = new EventGun();
MyListener initok = new MyListener();

// bool initok = false;
void main() async {
  initok.value = false;
  init(gun).then((x) => initok.value = true);
  try {
    runApp(MyApp());
  } catch (e) {
    print(e);
  }
}

//用于生成一个加载页面
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    if (!initok.value) {
      initok.afterSetter = () => setState(() {});
      return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue), home: Scaffold(body: Center(child: Text(Appdata.loadingtext))));
    } else
      return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue), home: MyHomePage());
  }
}

mixin HomePageMixin on State<MyHomePage> {
  PageController _pctler;
  DateTime _lastPressAt;
  checkOnWillPop() {
    var f = (_lastPressAt != null &&
        _pctler.page <= _pctler.initialPage &&
        DateTime.now().difference(_lastPressAt) < Duration(seconds: 1));

    _lastPressAt = DateTime.now();
    if (!f) _pctler.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    return f;
  }

  void openpage([page = 1]) =>
      this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin, HomePageMixin {
  @override
  bool get wantKeepAlive => true;
  PageController _pctler;
  ScrollController _menuCtr;
  ScrollController _chapterCtr;

  @override
  Widget build(BuildContext context) {
    var _tbs = [
      PageOne(itemonpress: (Book bk) {
        BookMark.currentBook = bk;
        openpage(1);
      }),
      MenuPage(itemonpress: (Book bk) => openpage(2), controller: this._menuCtr),
      ChapterPage(controller: this._chapterCtr)
    ];
    super.build(context);
    var size=MediaQuery.of(context).size;
    Appdata.width=size.width;
    Appdata.height=size.height;
    return WillPopScope(
        onWillPop: () async => checkOnWillPop(),
        child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pctler,
            itemCount: _tbs.length,
            itemBuilder: (context, index) => _tbs[index]));
  }

  @override
  void dispose() {
    Appdata.instance.pageController = null;
    this._pctler.dispose();
    this._menuCtr.dispose();
    this._chapterCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._pctler = PageController(initialPage: 0);
    Appdata.instance.pageController = _pctler;
    this._menuCtr = ScrollController(initialScrollOffset: 1.0, keepScrollOffset: true);
    this._chapterCtr = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  }
}
