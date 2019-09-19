import 'package:flutter/material.dart';
import "main_page_shaixuan.dart";
import 'package:aaa/data.dart';
import 'data_type_support.dart';

class Shujia extends StatefulWidget {
  Shujia({Key key, this.itemonpress}) : super(key: key);
  final Function itemonpress;
  @override
  _ShujiaState createState() {
    return _ShujiaState(itemonpress: this.itemonpress);
  }
}

class _ShujiaState extends State<Shujia> with SingleTickerProviderStateMixin {
  _ShujiaState({this.itemonpress}) : super();
  final Function itemonpress;
  TabController _p1ctl;
  @override
  void initState() {
    _p1ctl = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    this._p1ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: ListView(
                      children: getCards(
                          ListenerBox.instance['bks'].value is List ? ListenerBox.instance['bks'].value : [],
                          context,
                          itemonpress))),
              Center(child: Text("关注"))
            ])));
  }
}

List<Widget> getCards(List bookList, BuildContext context, Function itemonpress) =>
    bookList.map((bk) => getCard(bk as BookData, context, actn: () => itemonpress(bk))).toList();

Widget getCard(BookData book, BuildContext context, {VoidCallback actn}) {
  return FlatButton(
      onPressed: actn,
      child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Container(
                padding: EdgeInsets.all(7),
                width: 74,
                height: 94,
                child: Container(child: Text(book.pic, style: TextStyle(color: Colors.grey, fontSize: 30)))),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(7),
                    height: 94,
                    child: Column(children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(book.name,
                              textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 20))),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(book.author + " | " + book.progress,
                              textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 10))),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text([book.state, book.lastupdatetime, book.lastupdatepagename].join(' | '),
                              textAlign: TextAlign.left, style: TextStyle(color: Colors.grey, fontSize: 10)))
                    ]))),
            Container(
                padding: EdgeInsets.all(7),
                height: 94,
                width: 50,
                child: IconButton(
                    color: Colors.grey,
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return getbookdataboard(book, context);
                          });
                    },
                    icon: Icon(Icons.more_horiz)))
          ])));
}

MaterialButton gmbutton(IconData icon, Color cl, String tt, VoidCallback op) {
  return MaterialButton(onPressed: op, child: Column(children: <Widget>[Icon(icon, size: 25, color: cl), stext(tt)]));
}

Widget getbookdataboard(BookData book, BuildContext context) {
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
                      child: Text(book.pic,
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
                      width: 70,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black), borderRadius: BorderRadius.circular(13)),
                      alignment: Alignment.center,
                      child: FlatButton(onPressed: () {}, child: stext("详情")))
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
                          child: Text(book.fensidengji,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 10,
                                  // decorationColor: Colors.blue,
                                  color: Colors.white,
                                  decoration: TextDecoration.none))),
                      Expanded(child: Container()),
                      Text(book.fensizhi.toString() + "粉丝值",
                          style: TextStyle(
                              fontSize: 13,
                              // decorationColor: Colors.blue,
                              color: Colors.grey[600],
                              decoration: TextDecoration.none)),
                      Icon(Icons.chevron_right)
                    ]))),
            Container(height: 1, color: Colors.grey),
            Container(
                height: 50,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  gmbutton(Icons.swap_horiz, book.dingzhi ? Colors.red : Colors.grey[200], "置顶", () {}),
                  gmbutton(Icons.swap_horiz, book.gengxintixing ? Colors.red : Colors.grey[200], "更新提配", () {}),
                  gmbutton(Icons.swap_horiz, book.zidongdingyue ? Colors.red : Colors.grey[200], "自动订阅", () {}),
                  gmbutton(Icons.message, book.shuyouquanxinxiaoxi ? Colors.red : Colors.grey[200], "书友圈", () {})
                ])),
            Container(height: 1, color: Colors.grey),
            Container(
                height: 50,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  gmbutton(Icons.arrow_downward, Colors.red, "批量定阅", () {}),
                  gmbutton(Icons.arrow_right, Colors.red, "移到分组", () {}),
                  gmbutton(Icons.share, Colors.red, "分享本书", () {}),
                  gmbutton(Icons.delete, Colors.red, "删除本书", () {})
                ])),
            Container(height: 1, color: Colors.grey),
            Container(
                height: 50,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  gmbutton(Icons.grade, book.tuijianpiao > 0 ? Colors.red : Colors.grey[200], "投推荐票", () {}),
                  gmbutton(Icons.call_made, book.yuepiao > 0 ? Colors.red : Colors.grey[200], "投月票", () {}),
                  gmbutton(Icons.attach_money, Colors.red, "打赏", () {}),
                  gmbutton(Icons.redeem, Colors.red, "红包", () {})
                ]))
          ])));
}
