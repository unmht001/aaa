// import 'package:aaa/init_fun.dart';
// import 'package:aaa/init_fun.dart';
import 'package:aaa/pck/page/search_page.dart';

import 'data_show_page.dart';
import 'regexp_test_page.dart';
import 'setting_page.dart';
import 'package:flutter/material.dart';
import '../../support.dart';
import "main_page_shaixuan.dart";
import '../../data_type.dart';

class PageOne extends StatefulWidget with RefreshProviderSTF {
  PageOne({Key key, Function itemonpress})
      : this.itemonpress = itemonpress ?? ((v) {}),
        super(key: key);
  final Function itemonpress;

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, RefreshProviderState {
  TabController _p1ctl;
  TabController _controller;
  TabController _c3;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _p1ctl = TabController(vsync: this, length: 2);
    _c3 = TabController(vsync: this, length: 2);
    this._controller = TabController(vsync: this, length: Appdata.instance.navs.length);
  }

  @override
  void dispose() {
    this._p1ctl.dispose();
    this._controller.dispose();
    _c3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

        //page 1
        body: TabBarView(physics: NeverScrollableScrollPhysics(), controller: _controller, children: <Widget>[
          bookcase(context),
          Scaffold(body: SearchPage()),
          Scaffold(body: TabBarView(controller: _c3, children: <Widget>[ContentSettingPage(), RegexpTestPage()])),
          DataShowPage()
        ]),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 24.0,
            currentIndex: _controller.index,
            fixedColor: Colors.red,
            items: navs(),
            onTap: (int x) => setState(() => _controller.index = x)));
  }

  List<BottomNavigationBarItem> navs() {
    List<BottomNavigationBarItem> _r = [];
    for (var x in (Appdata.instance.navs)) _r.add(BottomNavigationBarItem(title: Text(x.tt), icon: Icon(x.icon)));
    return _r;
  }

  Widget bookcase(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            leading: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: FlatButton(
                    textColor: Colors.white,
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (context, a, b) => Shaixuan(),
                          barrierDismissible: false,
                          barrierLabel: 'barrierLabel',
                          transitionDuration: Duration(milliseconds: 400));
                    },
                    child: Text("筛选", style: TextStyle(fontSize: 13)),
                    shape: StadiumBorder(side: BorderSide(width: 1, color: Colors.white)))),
            title: TabBar(
                controller: _p1ctl,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.white,
                tabs: <Widget>[Tab(text: "书架"), Tab(text: "关注")])),
        body: Container(
            alignment: Alignment.center,
            child: TabBarView(controller: _p1ctl, children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: ListView.builder(itemCount: Bookcase.bookStore.length, itemBuilder: getCard)),
              Center(child: Text("关注"))
            ])));
  }

  Widget getCard(BuildContext context, int index) {
    Book bk = Bookcase.bookStore[Bookcase.bookStore.keys.toList()[index]];

    return FlatButton(
        onPressed: () => this.widget.itemonpress(bk),
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Container(
                  padding: EdgeInsets.all(7),
                  width: 74,
                  height: 94,
                  child: Container(child: Text(bk.pic ?? "图片", style: TextStyle(color: Colors.grey, fontSize: 30)))),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(7),
                      height: 94,
                      child: Column(children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(bk.name,
                                textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 20))),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(bk.author + " | " + (bk.progress ?? "未知"),
                                textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 10))),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                [bk.state ?? "未知", bk.lastupdatetime ?? "未知", bk.lastupdatepagename ?? "未知"]
                                    .join(' | '),
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.grey, fontSize: 10)))
                      ]))),
              Container(
                  padding: EdgeInsets.all(7),
                  height: 94,
                  width: 50,
                  child: IconButton(
                      color: Colors.grey,
                      alignment: Alignment.centerRight,
                      onPressed: () =>
                          showDialog(context: context, builder: (context) => getbookdataboard(context, bk)),
                      icon: Icon(Icons.more_horiz)))
            ])));
  }

  Widget getbookdataboard(BuildContext context, Book book) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Container(
                  height: 70,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Container(
                        height: 65,
                        width: 50,
                        child: Text(book.pic ?? "图片",
                            style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none))),
                    Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(book.name,
                              softWrap: false,
                              style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
                          stext(book.author)
                        ])),
                    Expanded(child: Container()),
                    Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(13)),
                        alignment: Alignment.center,
                        child: FlatButton(
                            onPressed: () {

                              
                            },
                            child: stext("详情")))
                  ])),
              Container(height: 1, color: Colors.grey),
              Container(
                  height: 40,
                  child: FlatButton(
                      onPressed: () {},
                      child: Row(children: <Widget>[
                        Text("我的粉丝值",
                            style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none)),
                        Container(
                            padding: EdgeInsets.all(2),
                            color: Colors.blue[300],
                            child: Text("见习",
                                softWrap: false,
                                style: TextStyle(fontSize: 10, color: Colors.white, decoration: TextDecoration.none))),
                        Expanded(child: Container()),
                        Text("0粉丝值",
                            style: TextStyle(fontSize: 13, color: Colors.grey[600], decoration: TextDecoration.none)),
                        Icon(Icons.chevron_right)
                      ]))),
              Container(height: 1, color: Colors.grey),
              Container(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    gmbutton(Icons.swap_horiz, Colors.grey[200], "置顶", () {}),
                    gmbutton(Icons.swap_horiz, Colors.grey[200], "更新提配", () {}),
                    gmbutton(Icons.swap_horiz, Colors.grey[200], "自动订阅", () {}),
                    gmbutton(Icons.message, Colors.grey[200], "书友圈", () {})
                  ])),
              Container(height: 1, color: Colors.grey),
              Container(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    gmbutton(Icons.arrow_downward, Colors.red, "批量定阅", () {}),
                    gmbutton(Icons.arrow_right, Colors.red, "移到分组", () {}),
                    gmbutton(Icons.share, Colors.red, "分享本书", () {}),
                    gmbutton(Icons.delete, Colors.red, "删除本书", () {
                              Navigator.pop(context);
                              Bookcase.deleteBook(book);
                              
                              BookMark.mainPageRefresher();

                    })
                  ])),
              Container(height: 1, color: Colors.grey),
              Container(
                  height: 50,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    gmbutton(Icons.grade, Colors.grey[200], "投推荐票", () {}),
                    gmbutton(Icons.call_made, Colors.grey[200], "投月票", () {}),
                    gmbutton(Icons.attach_money, Colors.red, "打赏", () {}),
                    gmbutton(Icons.redeem, Colors.red, "红包", () {})
                  ]))
            ])));
  }

  MaterialButton gmbutton(IconData icon, Color cl, String tt, VoidCallback op) =>
      MaterialButton(onPressed: op, child: Column(children: <Widget>[Icon(icon, size: 25, color: cl), stext(tt)]));
}
