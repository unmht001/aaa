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
  ScrollController get controller => Appdata.instance.chapterPageController;
  Chapter get chapter => BookMark.currentBook.getBookstate.currentChapter;

  @override
  _ChapterViewListState createState() => _ChapterViewListState();

  @override
  Book get book => this.chapter.book;
}

class _ChapterViewListState extends State<ChapterViewList>
    with AutomaticKeepAliveClientMixin, RefreshProviderState, ReaderState {
  SectionSheet get thisFireS => this.widget.book.getBookstate.currentChapter.contentStart;

  ScrollController controller;
  @override
  bool get wantKeepAlive => true;
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
  refresh([Function fn]) {
    if (!Appdata.isAppOnBack && this.mounted && Appdata.instance.pageController.page >=1.5 && Appdata.instance.pageController.page <=2.5 ) {
      setState(fn == null ? ([x]) {} : fn);
      return true;
    }
    return false;
  }

  @override
  pagemove([SectionSheet sss]) {
    var p = Appdata.instance.pageController?.page;
    if (sss == null) {
      this.widget.controller.position.moveTo(0);
    } else if (p != null && p > 1.5 && p < 2.5)
      this.widget.controller.position.moveTo(this.widget.controller.position.pixels + sss.height);
  }

  sectionSheet2Card(SectionSheet sss) {
    return Container(
        key: sss.sgk,
        color: book.getBookstate.isreading && sss.isHighlight ? Colors.greenAccent[100] : sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () {
              currentHL = sss;
              currentHL.highLight();
              smartReading();
              refresh();
            }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("build ChapterPage");
    if (this.widget.chapter == null || this.widget.book == null) return Container(color: Colors.brown[200]);
    Widget _r;
    try {
      _r = GestureDetector(
          onHorizontalDragEnd: (detail) => refresh(changeChapter(detail.primaryVelocity)),
          child: Container(
              child: DraggableScrollbar(
                  controller: this.widget.controller,
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
                      controller: this.widget.controller,
                      itemCount: this.widget.chapter.contentStart.genChildren + 1,
                      itemBuilder: (context, index) =>
                          sectionSheet2Card(this.widget.chapter.contentStart.getGen(index))))));
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
      log(e);
    }

    return _r;
  }
}
