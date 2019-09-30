import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'Refresh_Provider.dart';
import 'data_type_support.dart';
// import 'progress.dart';

class MenuPage extends StatelessWidget {
  final Function itemonpress;
  final ScrollController controller;

  MenuPage({this.itemonpress, this.controller});

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(body: MenuViewList(controller: controller, itemonpress: itemonpress));
    } catch (e) {
      return Scaffold(body: Container(child: Text(e.toString(), softWrap: true)));
    }
  }
}

class MenuViewList extends StatefulWidget with RefreshProviderSTF {
  final Function itemonpress;
  final ScrollController controller;
  MenuViewList({Key key, this.controller, this.itemonpress}) : super(key: key);
  @override
  _MenuViewListState createState() => _MenuViewListState();
}

class _MenuViewListState extends State<MenuViewList> with RefreshProviderState, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List get menu => BookMark.currentBook.menu;
  int get selected => (BookMark.currentBook.getBookstate.currentChapter?.index) ?? 0;
  bool built = false;
  @override
  void initState() {
    super.initState();
    BookMark.menuPageRefresher = () {
      if (BookMark.menuPageNeedToRefresh) {
        BookMark.menuPageNeedToRefresh = false;
        Future.delayed(Duration(milliseconds: 200), () => setState(() {}));
      }
    };
    // BookMark.menuPageRefresher = () => setState(() {});
  }

  @override
  void dispose() {
    BookMark.menuPageRefresher = () {};
    super.dispose();
  }

  Widget makeItem(BuildContext context, int index) {
    Chapter chapter = menu[index];
    return index == null
        ? FlatButton(onPressed: () {}, child: Text("目录载入中...", softWrap: true))
        : FlatButton(
            color: index == selected ? Colors.brown[200] : Colors.white,
            child: Text(chapter.chapterName.toString(), softWrap: true),
            onPressed: () {
              chapter.book.getBookstate.currentChapter = chapter;
              this.widget.itemonpress(BookMark.currentBook);
            });
  }

  getL() {
    Widget _r;
    if (!BookMark.currentBook.getBookstate.isMenuLoaded) {
      _r = ListView(children: <Widget>[FlatButton(onPressed: () {}, child: Text("目录载入中...", softWrap: true))]);

      BookMark.currentBook.getMenu().then((x) async {
        if (x is List) BookMark.currentBook.menu = x.map((a) => Chapter(a[0], a[1])).toList();
      }).then((x) => setState(() {
            print(222);
          }));
    } else
      _r = ListView.builder(
          reverse: false,
          controller: this.widget.controller,
          itemCount: menu.length,
          itemBuilder: (context, index) => makeItem(context, menu.length - 1 - index));
    return _r;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build menu");
    Widget _r;
    try {
      _r = Container(
          child: DraggableScrollbar(
              controller: this.widget.controller,
              heightScrollThumb: 50,
              backgroundColor: Colors.blue,
              scrollThumbBuilder: (Color backgroundColor, Animation<double> thumbAnimation,
                      Animation<double> labelAnimation, double height,
                      {Text labelText, BoxConstraints labelConstraints}) =>
                  FadeTransition(
                      opacity: thumbAnimation, child: Container(height: height, width: 20.0, color: backgroundColor)),
              child: getL()));
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
    }
    return _r;
    // return Container();
  }
}
