// import 'package:aaa/pck/page/get_more_widget.dart';
import 'package:aaa/pck/support/logS.dart';
// import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/gestures/recognizer.dart';
// import 'package:flutter/src/rendering/viewport_offset.dart';

import '../../support.dart';
import '../../data_type.dart';
// import 'progress.dart';

class MenuPage extends StatelessWidget {
  final Function itemonpress;
  final ScrollController controller;

  MenuPage({this.itemonpress, this.controller});

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          body: MenuViewList(key: ValueKey(Appdata.menuKey), controller: controller, itemonpress: itemonpress));
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

  bool isLoading = false;
  bool showmore = false;
  bool offState = false;

  @override
  void initState() {
    rs = BookMark.menuRs;
    super.initState();
    BookMark.menuPageRefresher = ([x]) {
      log("menuPageRefresher");
      if (BookMark.menuPageNeedToRefresh && refresh()) BookMark.menuPageNeedToRefresh = false;
      if(menu.isEmpty ||(menu.length==1 && (menu[0] as Chapter).content==new Chapter().content ) )
        onDraw();
    };
  }

  @override
  void dispose() {
    BookMark.menuPageRefresher = ([x]) {
      log("menuPageRefresher Null action");
    };
    super.dispose();
  }

  refresh([Function fn]) {
    if (!Appdata.isAppOnBack && this.mounted) {
      (fn == null ? ([x]) {} : fn)();
      setState(() {});
      return true;
    }
    return false;
  }

  Widget makeItem(BuildContext context, int index) {
    Chapter chapter = menu[index];
    return FlatButton(
        color: index == selected ? Colors.brown[200] : Colors.white,
        child: Text(chapter.chapterName.toString(), softWrap: true),
        onPressed: () {
          chapter.book.getBookstate.currentChapter = chapter;
          this.widget.itemonpress(BookMark.currentBook);
        });
  }

  Future<void> onDraw() async {
    await BookMark.currentBook.getMenu();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build menu");

    var v = rs.isGreen;
    rs.goRed();

    Widget _r;
    try {
      _r = Container(
          child: ViewTest(
        controller: this.widget.controller,
        itemCount: !BookMark.currentBook.getBookstate.isMenuLoaded || menu.isEmpty ? 1 : menu.length,
        itemBuilder: (context, id) => (!BookMark.currentBook.getBookstate.isMenuLoaded || menu.isEmpty)
            ? Center(child: FlatButton(onPressed: onDraw, child: Text("点击刷新")))
            : makeItem(context, menu.length - 1 - id),
        onLoading: () async {
          print("menu onload action......");
          // await Future.delayed(Duration(seconds: 2));
          await BookMark.currentBook.getMenu();
          print("menu onLoad action over");
          refresh();
          return true;
        },
      ));
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
    }
    if (v) rs.goGreen();
    return _r;
  }
}
