import 'package:aaa/support.dart';

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
  var s = new RoadSignal();
  // DateTime t1;
  @override
  void initState() {
    super.initState();
    rs = BookMark.chapterRs;
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
    if (Appdata.isAppOnBack) print("refresh: Appdata.isAppOnBack: ${Appdata.isAppOnBack}");
    log("refresh");
    var page = Appdata.instance.pageController.page;
    if (!Appdata.isAppOnBack && this.mounted && page >= 1.5 && page <= 2.5) setState((fn == null ? ([x]) {} : fn));

    return true;
  }

  @override
  pagemove([SectionSheet sss]) {
    if (!Appdata.isAppOnBack) {
      if (sss == null)
        controller.position.moveTo(0);
      else if ((sss.genFather ?? 0) < -3) {
        var p = Appdata.instance.pageController?.page;
        var s = controller.position.maxScrollExtent * sss.genFather * -1 / sss.first.genChildren +
            Appdata.height * (sss.genFather * -1 / sss.first.genChildren - 0.5);
        if (p != null && p > 1.5 && p < 2.5 && s >= 0)
          controller.position.animateTo(s,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    } else {
      print("pagemove: Appdata.isAppOnBack: ${Appdata.isAppOnBack}");
    }
  }

  sectionSheet2Card(SectionSheet sss) {
    return Container(
        // key: sss.sgk,
        color: book.getBookstate.isreading && sss.isHighlight ? Colors.greenAccent[100] : sss?.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text((sss?.text)??"", softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => smartReading(sss)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("build ChapterPage");
    Widget _r;
    checkState();
    rs.goRed();
    try {
      if (this.widget.chapter == null || this.widget.book == null)
        _r = Container(color: Colors.brown[200]);
      else
        _r = GestureDetector(
            onHorizontalDragEnd: (detail) => refresh(changeChapter(detail.primaryVelocity)),
            child: Container(
                child: ViewTest(
                    onLoading: () async {
                      // DateTime t2=DateTime.now();
                      
                      print("page onload action......");
                      this.widget.chapter.isloaded = false;
                      stopReading();
                      if (this.widget.chapter.isloading) {
                        await this.widget.chapter.waitLoadOver();
                        refresh();
                        startReading();
                      } else {
                        await this.widget.chapter.loadChapterContent();
                        refresh();
                        startReading();
                      }
                      print("page onLoad action over");
                      checkState();
                      return true;
                    },
                    controller: controller,
                    itemCount: this.widget.chapter.contentStart.genChildren + 1,
                    itemBuilder: (context, index) =>
                        sectionSheet2Card(this.widget.chapter.contentStart.getGen(index)))));
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
      log(e);
    }
    rs.goGreen();
    return _r;
  }
}
