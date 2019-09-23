import 'package:flutter/material.dart';
import 'init_fun.dart';
import 'pck/main_page.dart';

import 'data.dart';
import 'pck/data_type_support.dart';
import 'pck/content_page.dart';
import 'pck/menu_page.dart';

EventGun gun = new EventGun();
MyListener initok = new MyListener();

// bool initok = false;
void main() async {
  initok.value = false;
  init(gun).then((bool) => initok.value = true);
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
          theme: ThemeData(primarySwatch: Colors.blue), home: Scaffold(body: Center(child: Text(loadingtext))));
    } else
      return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue), home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  PageController _pctler;
  ScrollController _menuCtr;
  DateTime _lastPressAt;
  checkOnWillPop() {
    var f = (_lastPressAt == null ||
            _pctler.page > _pctler.initialPage ||
            DateTime.now().difference(_lastPressAt) > Duration(seconds: 1))
        ? false
        : true;

    _lastPressAt = DateTime.now();
    if (!f) _pctler.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    return f;
  }

  @override
  Widget build(BuildContext context) {
    var _tbs = [
      PageOne(itemonpress: onShujiaPress),
      MenuPage(
        itemonpress: onMenuPress,
        controller: this._menuCtr,
      ),
      ContentPage(pageReadOverAction: onPagePress)
    ];
    super.build(context);
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
    this._pctler.dispose();
    this._menuCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._pctler = PageController(initialPage: 0);
    this._menuCtr = ScrollController(initialScrollOffset: 1.0, keepScrollOffset: true);
  }

  void openpage(Book bk, {int page: 1}) =>
      this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);

  onShujiaPress(Book bk) {
    BookMark.currentBook = bk;
    openpage(bk, page: 1);
    bk.getMenu().then((x) {
      if (x is List) bk.menu = x.map((a) => Chapter(a[0], a[1])).toList();
      BookMark.menuLoadedLsn.value = true;
    });
  }

  onMenuPress(Book bk) => openpage(bk, page: 2);

  onPagePress(BookData bk) async {
    // if (ListenerBox.instance['bk'].value.selected > 0) {
    //   ListenerBox.instance['bk'].value.selected -= 1;
    //   (ListenerBox.instance['bk'].value as BookData).getpagedata();
    // }
  }
}
//19.09.19
//TODO: 一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30%
//TODO: 自动加载前三后三共七页.这个功能还没开始做

//19.09.20
//TODO: APP 分层       底层访问 -- 数据结构 --  界面显示    , 重写 APP架构以解决 19.09.19的问题.

//19.09.23
//DONE: 用 draggable_scrollbar 代替 自己的progress
