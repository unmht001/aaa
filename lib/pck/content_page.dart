//文本内容显示阅读页
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import 'data_type_support.dart';
// import 'progress.dart';

class ReaderData {
  SectionSheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

mixin Reader on StatefulWidget {
  final ReaderData pst = new ReaderData(); //用来表示阅读器
  Book get book;
  Mytts8 get tts => gettts();
  static gettts() {
    if (ListenerBox.instance['tts'].value is String) print('tts init error');
    return ListenerBox.instance['tts'].value;
  }
}

mixin ReaderState<T extends Reader> on State<T> {
  Book get book => this.widget.book;
  ReaderData get pst => this.widget.pst;
  Mytts8 get tts => this.widget.tts;
  continueReading() async {
    if (await tts.isLanguageAvailable('zh-CN'))
      setState(() {
        tts.setCompletionHandler(() => setState(() {
              if (pst.currentHL.son != null) {
                pst.currentHL.disHighLight();
                pst.currentHL = pst.currentHL.son;
                pst.currentHL.highLight();
                continueReading();
              } else
                pst.readingCompleteHandler(book);
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

  refreshpage() {
    //   book.pageLsn.value = this.widget.pst.currentHL = book.pageLsn.value is String
    //       ? SectionSheet.getSectionSheetChain(this.widget.lsn.value)
    //       : book.pageLsn.value as SectionSheet;

    //   book.pageLsn.value.highLight();
    //   if (this.mounted) setState(() {});
    // }
  }
}

class ChapterPage extends StatelessWidget {
  final ScrollController controller;
  final Function pageReadOverAction;
  ChapterPage({this.controller,this.pageReadOverAction});  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChapterViewList(pageReadOverAction: this.pageReadOverAction, controller: this.controller),
    );
  }
}


class ChapterViewList extends StatefulWidget with RefreshProviderSTF, Reader {
  final ScrollController controller;
  Chapter get  chapter=>BookMark.currentBook.getBookstate.currentChapter;
  ChapterViewList({Key key, Function pageReadOverAction, this.controller}) : super(key: key) {
    this.pst.readingCompleteHandler = pageReadOverAction; //设置阅读器读完本页后的动作
  }

  @override
  _ChapterViewListState createState() => _ChapterViewListState();

  @override
  Book get book => this.chapter.book;
}

class _ChapterViewListState extends State<ChapterViewList> with RefreshProviderState, ReaderState {
  sectionSheet2Card(SectionSheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => setState(() {
                  // if (this.widget.pst.currentHL != null) this.widget.pst.currentHL.disHighLight();
                  // this.widget.pst.currentHL = sss;
                  // this.widget.pst.currentHL.highLight();
                  // this.book.readingLsn.value = !this.book.readingLsn.value;
                  // this.book.readingLsn.value ? startReading() : stopReading();
                })));
  }

  @override
  Widget build(BuildContext context) {
    print("build menu");
    if (this.widget.chapter == null || this.widget.book == null)
      return Container(
        color: Colors.brown[200],
      );

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
              child: ListView.builder(
                  reverse: false,
                  controller: this.widget.controller,
                  itemCount: this.widget.chapter.contentStart.genChildren + 1,
                  itemBuilder: (context, index) => sectionSheet2Card(this.widget.chapter.contentStart.getGen(index)))));
      if (!this.widget.chapter.isloaded) {
        this.widget.chapter.initContent().then((x) => setState(() { print("initContent over");}));
      }
    } catch (e) {
      _r = Container(child: Text(e.toString(), softWrap: true));
    }
    return _r;
  }
}

// class ContentPage extends StatefulWidget with RefreshProviderSTF, Reader {
//   final Book book;
//   ContentPage({Key key, Function pageReadOverAction, this.book}) : super(key: key) {
//     this.pst.readingCompleteHandler = pageReadOverAction; //设置阅读器读完本页后的动作
//   }

//   @override
//   _ContentPageState createState() => _ContentPageState();
// }

// class _ContentPageState extends State<ContentPage>
//     with RefreshProviderState, AutomaticKeepAliveClientMixin, ReaderState {
//   @override
//   bool get wantKeepAlive => true;
//   ProgressValue get pv => this.widget.book.pagePv;
//   @override
//   get book => BookMark.currentBook;
//   final _ctr = new ScrollController(keepScrollOffset: true);

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//         child: Column(children: <Widget>[
//       Expanded(
//           child: NotificationListener(
//               onNotification: (ScrollNotification note) {
//                 pv.max = (note.metrics.maxScrollExtent - note.metrics.minScrollExtent);
//                 pv.value = (note.metrics.pixels - note.metrics.minScrollExtent);
//                 setState(() {});
//                 return true;
//               },
//               child: book.pageLsn.value is String
//                   ? ListView(controller: _ctr, children: <Widget>[])
//                   : ListView(controller: _ctr, children: chainToWidgetList(book.pageLsn.value as SectionSheet)))),
//       Container(
//           padding: EdgeInsets.all(5),
//           height: 50,
//           child: ClipRRect(
//               // 边界半径（`borderRadius`）属性，圆角的边界半径。
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               child: ProgressDragger(
//                 _ctr,
//                 color: Colors.yellow,
//                 onTapUp: (d) {
//                   _ctr.animateTo(pv.value, duration: Duration(milliseconds: 500), curve: Curves.ease);
//                 },
//                 onVerticalDragUpdate: (d) {
//                   _ctr.animateTo(pv.value, duration: Duration(milliseconds: 500), curve: Curves.ease);
//                 },
//                 valueColor: AlwaysStoppedAnimation(Colors.red),
//               )))
//     ]));
//   }

//   List<Widget> chainToWidgetList(Chain sss) {
//     List<Widget> a = [];
//     var b = sss;
//     while (b != null) {
//       a.add(textsheetToWidget(b));
//       b = b.son;
//     }
//     return a;
//   }

//   @override
//   dispose() {
//     this.book.pageLsn.afterSetter = () {};
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     this.widget.pst.currentHL = this.book.pageLsn.value = this.book.pageLsn.value is String
//         ? SectionSheet.getSectionSheetChain(this.widget.lsn.value)
//         : this.book.pageLsn.value as SectionSheet;
//     this.book.pageLsn.afterSetter = refreshpage;
//     if (this.book.pageLsn.value != null) this.book.pageLsn.value.highLight();
//     ListenerBox.instance['cpLoaded'].afterSetter = () {
//       if (book.readingLsn.value) startReading();
//     };
//     // this.widget.book.getpagedata().then((x) => setState(() {}));
//   }

//   Widget textsheetToWidget(SectionSheet sss) {
//     return Container(
//         color: sss.cl,
//         padding: EdgeInsets.all(5),
//         child: GestureDetector(
//             child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
//             onTap: () => setState(() {
//                   if (this.widget.pst.currentHL != null) this.widget.pst.currentHL.disHighLight();
//                   this.widget.pst.currentHL = sss;
//                   this.widget.pst.currentHL.highLight();
//                   this.book.readingLsn.value = !this.book.readingLsn.value;
//                   this.book.readingLsn.value ? startReading() : stopReading();
//                 })));
//   }
// }
