// import 'package:aaa/init_fun.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';
import '../data.dart';
import 'Refresh_Provider.dart';
import 'data_type_support.dart';

class ReaderData {
  SectionSheet currentHL;
  Function readingCompleteHandler;
}

mixin Reader on StatefulWidget {
  final ReaderData pst = new ReaderData(); //用来表示阅读器
  Book get book;
  Mytts8 get tts => gettts();
  static gettts() {
    return Appdata.instance.tts;
  }
}

mixin ReaderState<T extends Reader> on State<T> {
  Book get book => this.widget.book;
  ReaderData get pst => this.widget.pst;
  Mytts8 get tts => this.widget.tts;
  // GlobalKey _gk;
  pagemove(SectionSheet sss);

  continueReading() async {
    if (await tts.isLanguageAvailable('zh-CN'))
      setState(() {
        tts.setCompletionHandler(() => setState(() async {
              if (pst.currentHL.son != null) {
                pst.currentHL.disHighLight();
                pst.currentHL = pst.currentHL.son;
                pst.currentHL.highLight();
                pagemove(pst.currentHL);
                continueReading();
              } else
                pst.readingCompleteHandler(1.0);
            }));
        if (book.getBookstate.isreading) this.widget.tts.speak(pst.currentHL.text);
      });
    else
      print('language is not available');
  }

  startReading() async {
    book.getBookstate.isreading = true;
    continueReading();
  }

  stopReading() async {
    book.getBookstate.isreading = false;
    tts.stop();
  }

  smartReading() async {
    book.getBookstate.isreading = !book.getBookstate.isreading;
    book.getBookstate.isreading ? continueReading() : tts.stop();
  }
}

class ChapterPage extends StatelessWidget {
  final ScrollController controller;
  ChapterPage({this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChapterViewList(controller: this.controller),
    );
  }
}

class ChapterViewList extends StatefulWidget with RefreshProviderSTF, Reader {
  final ScrollController controller;
  Chapter get chapter => BookMark.currentBook.getBookstate.currentChapter;
  ChapterViewList({Key key, this.controller}) : super(key: key) {
    this.pst.readingCompleteHandler = (double v) {
      num f1 = BookMark.currentBook.getBookstate.currentChapter.index;
      num f2 = BookMark.currentBook.menu.length;
      num f3 = (v < 0 && f1 < f2 - 1) ? 1 : (v > 0 && f1 > 1) ? -1 : null;
      if (f3 != null) BookMark.currentBook.getBookstate.currentChapter = BookMark.currentBook.menu[f1 + f3];
    }; //设置阅读器读完本页后的动作
  }

  @override
  _ChapterViewListState createState() => _ChapterViewListState();

  @override
  Book get book => this.chapter.book;
}

class _ChapterViewListState extends State<ChapterViewList>
    with AutomaticKeepAliveClientMixin, RefreshProviderState, ReaderState {
  SectionSheet get thisFireS => this.widget.book.getBookstate.currentChapter.contentStart;

  @override
  void initState() {
    super.initState();

    BookMark.chapterPageRefresher = () {
      if (BookMark.chapterPageNeedToRefresh){
        BookMark.chapterPageNeedToRefresh=false;
        Future.delayed(Duration(seconds: 1), () => setState(() {}));
      }
      
    };
  }

  @override
  bool get wantKeepAlive => true;
  @override
  pagemove(SectionSheet sss) {
    var p = Appdata.instance.pageController?.page;
    if (p != null && p > 1.5 && p < 2.5)
      this.widget.controller.position.moveTo(this.widget.controller.position.pixels + sss.height);
  }

  sectionSheet2Card(SectionSheet sss) {
    return Container(
        key: sss.sgk,
        color: book.getBookstate.isreading && sss.isHighlight ? Colors.greenAccent[100] : sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => setState(() {
                  this.widget.pst.currentHL = sss;
                  this.widget.pst.currentHL.highLight();
                  smartReading();
                })));
  }

  toNextChapter() {
    this
        .widget
        .chapter
        .initContent()
        .then((x) => Future.delayed(
            Duration(seconds: 1),
            () => setState(() {
                  this.widget.pst.currentHL = book.getBookstate.currentChapter.contentStart;
                  print("initContent over : $x");
                })))
        .then((x) => startReading())
        .then((x) => this.widget.controller.jumpTo(0));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build ChapterPage");
    if (this.widget.chapter == null || this.widget.book == null) return Container(color: Colors.brown[200]);
    Widget _r;
    try {
      _r = GestureDetector(
          onHorizontalDragEnd: (detail) =>
              setState(() => this.widget.pst.readingCompleteHandler(detail.primaryVelocity)),
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
      if (!this.widget.chapter.isloaded && !this.widget.chapter.isloading)
        toNextChapter();
      else if (this.widget.chapter.isloaded) {
        if (this.widget.pst.currentHL == null || this.widget.pst.currentHL.first != this.widget.chapter.contentStart) {
          this.widget.pst.currentHL = this.widget.chapter.contentStart;
          this.widget.pst.currentHL.highLight();
          setState(() {});
        }
      } else if (this.widget.pst.currentHL.isHighlight == false) {
        this.widget.pst.currentHL.highLight();
        setState(() {});
      }
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
    }
    return _r;
  }
}
