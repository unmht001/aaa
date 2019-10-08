// import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import '../../data_type.dart';
import '../../support.dart' show Reader, RefreshProviderSTF, RefreshProviderState, ReaderState, log;

class ChapterPage extends StatelessWidget {
  ScrollController get controller => Appdata.instance.chapterPageController;

  ChapterPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChapterViewList());
  }
}

class ChapterViewList extends StatefulWidget with RefreshProviderSTF, Reader {
  Chapter get chapter => BookMark.currentBook.getBookstate.currentChapter;
  set chapter(Chapter v) => BookMark.currentBook.getBookstate.currentChapter = v;

  @override
  _ChapterViewListState createState() => _ChapterViewListState();
}

class _ChapterViewListState extends State<ChapterViewList>
    with AutomaticKeepAliveClientMixin, RefreshProviderState, ReaderState {
  SectionSheet get thisFireS => this.widget.book.getBookstate.currentChapter.contentStart;
  SectionSheet get currentHL => book.getBookstate.currentHL;
  set currentHL(SectionSheet ss) => book.getBookstate.currentHL = ss;
  bool get wantKeepAlive => true;
  bool get isReadingMode => Appdata.isReadingMode;
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    this.controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    Appdata.instance.chapterPageController = controller;
    BookMark.chapterPageRefresher = ([x]) {
      log("chapterPageRefresher");
      checkState();
      if (BookMark.chapterPageNeedToRefresh && refresh()) BookMark.chapterPageNeedToRefresh = false;
    };
  }

  @override
  void dispose() {
    Appdata.instance.chapterPageController = null;
    this.controller.dispose();
    BookMark.chapterPageRefresher = ([x]) {};
    super.dispose();
  }

  @override
  markRefresh() {
    BookMark.menuPageNeedToRefresh = true;
    BookMark.chapterPageNeedToRefresh = true;
  }

  @override
  refresh([Function fn]) {
    log("refresh");
    var page = Appdata.instance.pageController.page;
    if (!Appdata.isAppOnBack && this.mounted && page >= 1.5 && page <= 2.5) setState((fn == null ? ([x]) {} : fn));

    return true;
  }

  @override
  pagemove([SectionSheet sss]) {
    if (!Appdata.isAppOnBack) {
      var p = Appdata.instance.pageController?.page;
      if (sss == null)
        controller.position.moveTo(0);
      else if (p != null && p > 1.5 && p < 2.5) controller.position.moveTo(controller.position.pixels + sss.height);
    }
  }

  sectionSheet2Card(SectionSheet sss) {
    return Container(
        key: sss.sgk,
        color: book.getBookstate.isreading && sss.isHighlight ? Colors.greenAccent[100] : sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => smartReading(sss)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("build ChapterPage");
    Widget _r;

    rs.goRed();
    try {
      if (this.widget.chapter == null || this.widget.book == null)
        _r = Container(color: Colors.brown[200]);
      else
        _r = GestureDetector(
            onHorizontalDragEnd: (detail) => refresh(changeChapter(detail.primaryVelocity)),
            child: Container(
                child: DraggableScrollbar(
                    controller: controller,
                    heightScrollThumb: 50,
                    backgroundColor: Colors.blue,
                    scrollThumbBuilder: (Color backgroundColor, Animation<double> thumbAnimation,
                            Animation<double> labelAnimation, double height,
                            {Text labelText, BoxConstraints labelConstraints}) =>
                        FadeTransition(
                            opacity: thumbAnimation,
                            child: Container(height: height, width: 20.0, color: backgroundColor)),
                    child: ListView.builder(
                        reverse: false,
                        controller: controller,
                        itemCount: this.widget.chapter.contentStart.genChildren + 1,
                        itemBuilder: (context, index) =>
                            sectionSheet2Card(this.widget.chapter.contentStart.getGen(index))))));
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
      log(e);
    }
    rs.goGreen();
    return _r;
  }
}
