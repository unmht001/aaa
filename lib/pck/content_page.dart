//文本内容显示阅读页
import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import 'data_type_support.dart';
import 'progress.dart';

class ContentPagedata {
  Textsheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

class ContentPage extends StatefulWidget {
  Mytts8 get tts => gettts();
  final ContentPagedata pst = new ContentPagedata(); //用来表示阅读器
  MyListener get lsn => book.pageLsn;
  BookData get book => ListenerBox.instance["bk"].value;
  ContentPage({Key key, Function pageReadOverAction}) : super(key: key) {
    this.pst.readingCompleteHandler = pageReadOverAction; //设置阅读器读完本页后的动作
  }

  @override
  _ContentPageState createState() => _ContentPageState(book: this.book);

  static gettts() {
    if (ListenerBox.instance['tts'].value is String) print('tts init error');
    return ListenerBox.instance['tts'].value;
  }
}

class _ContentPageState extends State<ContentPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ProgressValue get pv => this.widget.book.pagePv;
  final _ctr = new ScrollController(keepScrollOffset: true);
  _ContentPageState({this.book});
  final BookData book;
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
              child: book.pageLsn.value is String
                  ? ListView(controller: _ctr, children: <Widget>[])
                  : ListView(controller: _ctr, children: chainToWidgetList(book.pageLsn.value as Textsheet)))),
      Container(
          padding: EdgeInsets.all(5),
          height: 50,
          child: ClipRRect(
              // 边界半径（`borderRadius`）属性，圆角的边界半径。
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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

  List<Widget> chainToWidgetList(Chain sss) {
    List<Widget> a = [];
    var b = sss;
    while (b != null) {
      a.add(textsheetToWidget(b));
      b = b.son;
    }
    return a;
  }

  @override
  dispose() {
    this.book.pageLsn.afterSetter = () {};
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.book.pageLsn.afterSetter = () {
      if (this.mounted) setState(() {});
    };
    this.widget.pst.currentHL = this.book.pageLsn.value = this.book.pageLsn.value is String
        ? Textsheet.getTextsheetChain(this.widget.lsn.value)
        : this.book.pageLsn.value as Textsheet;
    this.book.pageLsn.afterSetter = refreshpage;
    if (this.book.pageLsn.value != null) this.book.pageLsn.value.highLight();
    ListenerBox.instance['cpLoaded'].afterSetter = () {
      if (book.readingLsn.value) startReading();
    };
  }

  continueReading() async {
    if (await this.widget.tts.isLanguageAvailable('zh-CN'))
      setState(() {
        this.widget.tts.setCompletionHandler(() => setState(() {
              if (this.widget.pst.currentHL.son != null) {
                this.widget.pst.currentHL.disHighLight();
                this.widget.pst.currentHL = this.widget.pst.currentHL.son;
                this.widget.pst.currentHL.highLight();
                continueReading();
              } else {
                this.book.readingLsn.value;
                this.widget.pst.readingCompleteHandler(this.widget.book);
              }
            }));
        if (this.book.readingLsn.value) this.widget.tts.speak(this.widget.pst.currentHL.text);
      });
    else
      print('language is not available');
  }

  startReading() async {
    this.book.readingLsn.value = true;
    // if (this.widget.lsn == ListenerBox.instance['pagedoc']) ListenerBox.instance['isreading'].value = true;
    continueReading();
  }

  stopReading() async {
    this.book.readingLsn.value = false;
    // if (this.widget.lsn == ListenerBox.instance['pagedoc']) ListenerBox.instance['isreading'].value = false;
    this.widget.tts.stop();
    setState(() {});
  }

  refreshpage() {
    book.pageLsn.afterSetter = () {};
    book.pageLsn.value = this.widget.pst.currentHL = book.pageLsn.value is String
        ? Textsheet.getTextsheetChain(this.widget.lsn.value)
        : book.pageLsn.value as Textsheet;
    book.pageLsn.afterSetter = refreshpage;
    book.pageLsn.value.highLight();
  }

  Widget textsheetToWidget(Textsheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () => setState(() {
                  if (this.widget.pst.currentHL != null) this.widget.pst.currentHL.disHighLight();
                  this.widget.pst.currentHL = sss;
                  this.widget.pst.currentHL.highLight();
                  this.book.readingLsn.value = !this.book.readingLsn.value;
                  this.book.readingLsn.value ? startReading() : stopReading();
                })));
  }
}
