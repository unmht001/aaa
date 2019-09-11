import 'package:aaa/data.dart';
import 'package:aaa/init_fun.dart';
import 'package:aaa/page2.dart';
import 'package:aaa/page3.dart';
import 'package:aaa/page4.dart';
import 'package:aaa/pck/get_string.dart';
import 'package:aaa/pck/tts_helper.dart';
import 'package:aaa/shujia.dart';
import 'package:flutter/material.dart';
import './pck/data_type_support.dart';

EventGun gun = new EventGun();
MyListener initok = new MyListener();

// bool initok = false;
void main() async {
  initok.value = false;
  init(gun).then((bool) => initok.value = true);
  runApp(MyApp());
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
      initok.afterSetter = () {
        setState(() {});
      };
      return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue), home: Scaffold(body: Container(child: Text(loadingtext))));
    } else {
      return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue), home: MyHomePage());
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _cindex = 0;
  TabController _controller;
  final PageController _pctler = new PageController();

  // BookData _bk;

  BookData _bk = new BookData();

  @override
  Widget build(BuildContext context) {
    return PageView(controller: _pctler, children: <Widget>[
      Scaffold(
          body: TabBarView(controller: _controller, children: <Widget>[
            Shujia(pa: [openpage]),
            Page2(),
            Page3(sdkdata: sdkdata),
            Page4()
          ]),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 24.0,
              currentIndex: _cindex,
              fixedColor: Colors.red,
              items: navs(),
              onTap: (int x) => setState(() {
                    _cindex = x;
                    _controller.index = x;
                  }))),
      Container(
        color: Colors.brown,
        child: MenuPage(itemonpress: (BookData bk) {

          openpage(bk,page:2);
        }),
      ),
      Container(
          color: Colors.brown,
          child: ContentPage(pageReadOverAction: () {
            if (ListenerBox.instance['bk'].value.selected == 0)
              print('readover');
            else {
              ListenerBox.instance['bk'].value.selected = ListenerBox.instance['bk'].value.selected - 1;
              PageOp.getpagedata();
            }
          }))
    ]);
  }

  List<BottomNavigationBarItem> navs() {
    List<BottomNavigationBarItem> _r = [];
    for (var x in (ListenerBox.instance['navs'].inited ? ListenerBox.instance['navs'].value : []))
      _r.add(BottomNavigationBarItem(title: Text(x.tt), icon: Icon(x.icon)));
    return _r;
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this._controller = TabController(
        vsync: this, length: ListenerBox.instance['navs'].inited ? ListenerBox.instance['navs'].value.length : 0);
    super.initState();
  }

  void openpage(BookData bk, {int page: 1}) {
    this._bk = bk;
    bk.menuLsn.afterSetter = () => setState(() {});
    PageOp.getmenudata(bk);
    this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
