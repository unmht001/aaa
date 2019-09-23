import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'data_type_support.dart';
// import 'progress.dart';

class MenuPage extends StatelessWidget {
  final Function itemonpress;
  final ScrollController controller;

  MenuPage({this.itemonpress, this.controller});
  List get menu => BookMark.currentBook.menu;

  int get selected => BookMark.bookState[BookMark.currentBook.uid].currentChapterIndex;

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(body: MenuViewList(controller: controller, builder: makeItem ,menu: menu,));
    } catch (e) {
      return Container(child: Text(e.toString(), softWrap: true));
    }
  }

  Widget makeItem(BuildContext context, int index) {
    return index == null
        ? FlatButton(onPressed: () {}, child: Text("目录载入中...", softWrap: true))
        : FlatButton(
            color: index == selected ? Colors.brown[200] : Colors.white,
            child: Text((menu[index] as Chapter).chapterName.toString(), softWrap: true),
            onPressed: () => () => (this.itemonpress ?? () {})());
  }
}

class MenuViewList extends StatefulWidget with RefreshProviderSTF {
  get menu=>menu;
  final ScrollController controller;
  final Function(BuildContext context, int index) builder;
  MenuViewList({Key key, this.controller, this.builder ,List<Chapter> menu}) : super(key: key);
  @override
  _MenuViewListState createState() => _MenuViewListState();
}

class _MenuViewListState extends State<MenuViewList> with RefreshProviderState {
  bool built = false;
  @override
  void initState() {
    super.initState();
    BookMark.menuPageRefresher = () => setState(() {});
  }

  @override
  void dispose() {
    if (BookMark.menuPageRefresher == () => setState(() {})) BookMark.menuPageRefresher = () {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build menu");
    Widget _r;
    if (this.built) {
      try {
        _r = DraggableScrollbar(
            controller: this.widget.controller,
            heightScrollThumb: 50,
            backgroundColor: Colors.blue,
            scrollThumbBuilder: (Color backgroundColor, Animation<double> thumbAnimation,
                    Animation<double> labelAnimation, double height,
                    {Text labelText, BoxConstraints labelConstraints}) =>
                FadeTransition(
                    opacity: thumbAnimation, child: Container(height: height, width: 20.0, color: backgroundColor)),
            child: ListView.builder(
                reverse: false,
                controller: this.widget.controller,
                itemCount: this.widget.menu.isEmpty ? 1 : this.widget.menu.length,
                itemBuilder: (context, index) =>
                    this.widget.builder(context, this.widget.menu.isEmpty ? null : this.widget.menu.length - 1 - index)));
      } catch (e) {
        _r = Container(child: Text(e.toString(), softWrap: true));
        Future.delayed(Duration(milliseconds: 500), () => setState(() {}));
      }
      return _r;
    }
    Future.delayed(Duration(milliseconds: 400), () => this.built = true).then((x) => setState(() {}));
    return Center(child: Text("loading"));
  }
}
