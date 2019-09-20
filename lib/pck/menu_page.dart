import 'package:flutter/material.dart';

import 'data_type_support.dart';
import 'progress.dart';

class MenuPage extends StatefulWidget {
  final Function itemonpress;
  BookData get book => ListenerBox.instance["bk"].value;
  MenuPage({this.itemonpress});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ProgressValue get pv => this.widget.book.menuPv;
  final _ctr = new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    this.widget.book.menuLsn.afterSetter = () {
      if (this.mounted) {
        setState(() {});
      }
    };
    this.widget.book.getmenudata().then((x) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: Column(children: <Widget>[
      Expanded(
          child: NotificationListener(
        onNotification: (ScrollNotification note) {
          pv.max = (note.metrics.maxScrollExtent - note.metrics.minScrollExtent);
          pv.value = (note.metrics.pixels - note.metrics.minScrollExtent);
          setState(() {});
          return true;
        },
        child: this.widget.book.menuLsn.value is List
            ? ListView.builder(
                itemCount: this.widget.book.menuLsn.value.length,
                controller: _ctr,
                itemBuilder: (BuildContext context, int index) => FlatButton(
                    color: this.widget.book.selected == this.widget.book.menuLsn.value.length - 1 - index
                        ? Colors.brown
                        : Colors.white,
                    child: Text(
                        this.widget.book.menuLsn.value[this.widget.book.menuLsn.value.length - 1 - index][1].toString(),
                        softWrap: true),
                    onPressed: () => setState(() {
                          this.widget.book.selected = this.widget.book.menuLsn.value.length - 1 - index;
                          this.widget.book.getpagedata();
                          // pv.offset = pv.value.toDouble();
                          if (this.widget.itemonpress != null) this.widget.itemonpress(this.widget.book);
                        })))
            : ListView(
                controller: _ctr, children: <Widget>[Text(this.widget.book.menuLsn.value.toString(), softWrap: true)]),
      )),
      Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: ClipRRect(
              // 边界半径（`borderRadius`）属性，圆角的边界半径。
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: ProgressDragger(
                pv,
                color: Colors.yellow,
                onTapUp: (d) {
                  _ctr.animateTo(pv.value, duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
                onVerticalDragUpdate: (d) {
                  _ctr.animateTo(pv.value, duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
                valueColor: AlwaysStoppedAnimation(Colors.red),
              )))
    ]));
  }
}
