import 'package:flutter/material.dart';

import 'data_type_support.dart';
import 'progress.dart';

class MenuPage extends StatefulWidget with RefreshProviderSTF {
  final Function itemonpress;
  MenuPage({this.itemonpress});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin, RefreshProviderSate {
  @override
  bool get wantKeepAlive => true;

  ProgressValue get pv => BookMark.bookState[BookMark.currentBook.uid].menupv;
  List get menu => BookMark.currentBook.menu;
  int get selected => BookMark.bookState[BookMark.currentBook.uid].currentChapterIndex;

  final _ctr = new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    BookMark.menuLoadedLsn.afterSetter = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget _r = Scaffold(
        body: Column(children: <Widget>[
      Expanded(
          child: NotificationListener(
              onNotification: (ScrollNotification note) {
                pv.max = (note.metrics.maxScrollExtent - note.metrics.minScrollExtent);
                pv.value = (note.metrics.pixels - note.metrics.minScrollExtent);
                return true;
              },
              child: menu.isEmpty
                  ? ListView(controller: _ctr, children: <Widget>[Text("目录载入中...", softWrap: true)])
                  : ListView.builder(reverse: true, itemCount: menu.length, controller: _ctr, itemBuilder: makeItem))),

      // (BuildContext context, int index) => FlatButton(
      //     color: index == selected ? Colors.brown[200] : Colors.white,
      //     child: Text(menu[selected][1].toString(), softWrap: true),
      //     onPressed: () => setState(() {
      //           // this.widget.book.selected = this.widget.book.menuLsn.value.length - 1 - index;
      //           // this.widget.book.getpagedata();
      //           // pv.offset = pv.value.toDouble();
      //           // if (this.widget.itemonpress != null) this.widget.itemonpress(this.widget.book);
      //         }))))),
      Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: ProgressDragger(
                _ctr,
                color: Colors.yellow,
                onTapUp: (d) => _ctr.jumpTo(pv.value),
                onVerticalDragUpdate: (d) => _ctr.jumpTo(pv.value),
                valueColor: AlwaysStoppedAnimation(Colors.red),
              )))
    ]));
    Future.delayed(Duration(microseconds: 1000), () => _ctr.jumpTo(pv.max.toDouble()));
    return _r;
  }

  Widget makeItem(BuildContext context, int index) {
    return FlatButton(
        color: index == selected ? Colors.brown[200] : Colors.white,
        child: Text((menu[index] as Chapter).chapterName.toString(), softWrap: true),
        onPressed: () => setState(() {
              // this.widget.book.selected = this.widget.book.menuLsn.value.length - 1 - index;
              // this.widget.book.getpagedata();
              // pv.offset = pv.value.toDouble();
              // if (this.widget.itemonpress != null) this.widget.itemonpress(this.widget.book);
            }));
  }
}
