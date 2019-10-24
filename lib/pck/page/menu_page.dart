import 'package:aaa/pck/page/get_more_widget.dart';
import 'package:aaa/pck/support/logS.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
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
    super.initState();
    BookMark.menuPageRefresher = ([x]) {
      log("menuPageRefresher");
      if (BookMark.menuPageNeedToRefresh && refresh()) BookMark.menuPageNeedToRefresh = false;
    };
  }

  @override
  void dispose() {
    BookMark.menuPageRefresher = ([x]) {};
    super.dispose();
  }

  refresh([Function fn]) {
    if (!Appdata.isAppOnBack &&
        this.mounted &&
        Appdata.instance.pageController.page > 0.5 &&
        Appdata.instance.pageController.page < 1.5) {
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

  getL() {
    Widget _r;
    if (!BookMark.currentBook.getBookstate.isMenuLoaded || menu.isEmpty)
      _r = ListView(controller: this.widget.controller, children: <Widget>[GetMore()]);
      // _r=C1(<Widget>[GetMore()]);
    // _r = RefreshIndicator(child: ListView(children: <Widget>[GetMore()]), onRefresh: onDraw);
    else
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
    rs.goRed();
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
    rs.goGreen();
    return _r;
    // return Container();
  }
}

