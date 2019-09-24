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
  ScrollController _chapterCtr;
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
      MenuPage(itemonpress: onMenuPress, controller: this._menuCtr),
      ChapterPage(controller: this._chapterCtr, pageReadOverAction: onPagePress)
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
    this._chapterCtr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._pctler = PageController(initialPage: 0);
    this._menuCtr = ScrollController(initialScrollOffset: 1.0, keepScrollOffset: true);
    this._chapterCtr = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  }

  void openpage(Book bk, {int page: 1}) =>
      this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);

  onShujiaPress(Book bk) {
    BookMark.currentBook = bk;
    openpage(bk, page: 1);
  }

  onMenuPress(Book bk) => openpage(bk, page: 2);

  onPagePress(BookData bk) async {
    // if (ListenerBox.instance['bk'].value.selected > 0) {
    //   ListenerBox.instance['bk'].value.selected -= 1;
    //   (ListenerBox.instance['bk'].value as BookData).getpagedata();
    // }
  }
}


//TODO: 内容页 的点击高亮和朗读还未实装. 之前使用的一些全局变量未清理. 下次要把这些完成.
//TODO: 1  一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30% //重构
//TODO: 2  .开始构想 书本设置页  包括换源, 手动设置正则条件, 内容提取正则化. 要不要开发一个小工具, 用于设计正则语句?
//TODO: 3  朗读TTS 不能调速, 后续要把 TTS的设置功能加入. 切记,TTS 开发不是主要任务,不能为了研究这个而耽误进度. 
//TODO:    这个APP完成以后, 下一步是写一个 AI 训练的APP, 用于训练自己的TTS, 以及图像模拟功能
//TODO: 4  后续要把IOS版开发出来. 以及用户注册功能,和,云端数据功能. //XX 不, 不开发IOS, 云端功能也暂后. 把本地储存功能完善.


//19.09.19 1.  00%
//TODO: 一个页面阅读后,能转到下一个页面. 现在可以跳转,但在跳转的时候出了BUG,  现在做到了30% 
//TODO: 自动加载前三后三共七页.这个功能还没开始做

//19.09.20 1.  30%
//TODO: APP 分层       底层访问 -- 数据结构 --  界面显示    , 重写 APP架构以解决 19.09.19的问题.

//19.09.23
//DONE: 用 draggable_scrollbar 代替 自己的progress

//19.09.24 1.  60%
//DONE: 三个面页都重构了,  正常的 书架页 目录页 内容页 已经架构结束, //前后加载 还没完成.



