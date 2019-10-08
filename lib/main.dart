import 'package:flutter/material.dart';

import 'init_fun.dart';
import 'data_type.dart';
import 'support.dart';

import 'pck/page/chapter_page.dart';
import 'pck/page/menu_page.dart';
import 'pck/page/main_page.dart';

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
    if (!f) {
      if (_pctler.page == 2.0) {
        var d = Duration(milliseconds: 300);
        _pctler.animateToPage(1, duration: d, curve: Curves.ease);
        Future.delayed(d, () => BookMark.menuPageNeedToRefresh = true);
      } else if (_pctler.page == 1.0) {
        _pctler.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }

    return f;
  }

  void openpage([page = 1]) {
    this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);
    Future.delayed(Duration(milliseconds: 300), () {
      BookMark.menuPageNeedToRefresh = true;
      BookMark.chapterPageNeedToRefresh = true;
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin, HomePageMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  PageController _pctler;
  ScrollController _menuCtr;
  ScrollController _chapterCtr;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool f = Appdata.isAppOnBack;
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        Appdata.isAppOnBack = true;
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        Appdata.isAppOnBack = true;
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        Appdata.isAppOnBack = false;
        break;
      case AppLifecycleState.suspending: // 申请将暂时暂停
        Appdata.isAppOnBack = false;
        break;
    }
    if (f && !Appdata.isAppOnBack)
      print("app--turn to back");
    else if (!f && Appdata.isAppOnBack) print("app--turn to top");
  }

  @override
  Widget build(BuildContext context) {
    var _tbs = [
      PageOne(itemonpress: (Book bk) {
        Appdata.instance.tts.stop();
        BookMark.currentBook = bk;
        openpage(1);
      }),
      MenuPage(
          
          controller: this._menuCtr,
          itemonpress: (Book bk) {
            Appdata.instance.tts.stop();
            openpage(2);
          }),
      ChapterPage()
    ];
    super.build(context);
    var size = MediaQuery.of(context).size;
    Appdata.width = size.width;
    Appdata.height = size.height;
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
  }
}
