import 'package:aaa/data.dart';
import 'package:aaa/init_fun.dart';
import 'package:aaa/page2.dart';
import 'package:aaa/page3.dart';
import 'package:aaa/page4.dart';
import 'package:aaa/shujia.dart';
import 'package:flutter/material.dart';
import './pck/data_type_support.dart';

void main() async {
  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue), home: MyHomePage());
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

  BookData _bk = new BookData();

  @override
  Widget build(BuildContext context) {
    if (!initok) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });

      return Scaffold(body: Container(child: Text(loadingtext)));
    }

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
              items: btms.map((NavData x) {
                return BottomNavigationBarItem(title: Text(x.tt), icon: Icon(x.icon));
              }).toList(),
              onTap: (int x) {
                setState(() {
                  _cindex = x;
                  _controller.index = x;
                });
              })),
      Container(
          color: Colors.brown,
          child: FlatButton(
              onPressed: () {
                openpage(this._bk, page: 0);
              },
              child: Container(color: Colors.brown, child: Text(this._bk.name + "返回"))))
    ]);
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    this._controller = TabController(vsync: this, length: btms.length);
    super.initState();
  }

  void openpage(BookData bk, {int page: 1}) {
    this._bk = bk;
    this._pctler.animateToPage(page, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
