// import 'package:aaa/pck/get_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mytts8/mytts8.dart';
// import '../data.dart';
import 'data_type_support.dart';
// import 'value_listener.dart';

class NoverMainPage extends StatelessWidget {
  final Function getmenudata;
  final Function itemonpress;
  NoverMainPage({Key key, this.getmenudata, this.itemonpress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ListenerBox.instance['bks'].value.length,
        itemBuilder: (BuildContext context, int index) => FlatButton(
            child: Text(ListenerBox.instance['bks'].value[index].name),
            onPressed: () {
              ListenerBox.instance['bk'].value = ListenerBox.instance['bks'].value[index];
              getmenudata();
              if (itemonpress != null) itemonpress();
            }));
  }
}

class SliderC extends StatefulWidget {
  final Function(double) fn;
  final String label;
  final MyListener lsn;
  SliderC(this.label, this.lsn, {Key key, this.fn}) : super(key: key);

  _SliderCState createState() => _SliderCState(label, fn: fn);
}

class _SliderCState extends State<SliderC> {
  _SliderCState(this.label, {BuildContext context, this.fn}) : super();
  final String label;
  Function(double) fn;
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Text(label),
      Container(
          width: 350,
          child: Slider(
            value: this.widget.lsn.value,
            onChanged: (v) {
              this.widget.lsn.value = (v * 100).toInt() / 100;
              setState(() {
                fn(this.widget.lsn.value);
              });
            },
            min: 0.5,
            max: 2,
            divisions: 15,
            label: '${this.widget.lsn.value}',
          ))
    ]);
  }
}

settingPage(BuildContext context, Function(double) onchange) {
  return ListView(children: <Widget>[
    Container(
      height: 50,
    ),
    SliderC("语速", ListenerBox.instance['speechrate'], fn: (double v) {
      ListenerBox.instance['tts'].value.setSpeechRate(v / 2);
      onchange(v);
    }),
    SliderC("语调", ListenerBox.instance['pitch'], fn: (double v) {
      ListenerBox.instance['tts'].value.setPitch(v);
      onchange(v);
    }),
    // SliderC("未用", fn: (double v) {
    //   onchange(v);
    // })
  ]);
}

class MenuPage extends StatelessWidget {
  final Function itemonpress;
  BookData get book => ListenerBox.instance["bk"].value;
  MenuPage({this.itemonpress});
  @override
  Widget build(BuildContext context) {
    return book.menuLsn.value is List
        ? ListView.builder(
            itemCount: book.menuLsn.value.length,
            itemBuilder: (BuildContext context, int index) => FlatButton(
                child: Text(book.menuLsn.value[book.menuLsn.value.length - 1 - index][1].toString(), softWrap: true),
                onPressed: () {
                  book.selected = book.menuLsn.value.length - 1 - index;
                  if (itemonpress != null) itemonpress(book);
                }))
        : ListView(children: <Widget>[Text(book.menuLsn.value.toString(), softWrap: true)]);
  }
}

//文本内容显示阅读页
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

class _ContentPageState extends State<ContentPage> {
  _ContentPageState({this.book});
  final BookData book;
  @override
  Widget build(BuildContext context) => book.pageLsn.value is String
      ? ListView(children: <Widget>[])
      : ListView(children: chainToWidgetList(book.pageLsn.value as Textsheet));

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
                this.widget.pst.readingCompleteHandler();
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
    book.pageLsn.afterSetter=(){};
    book.pageLsn.value=this.widget.pst.currentHL  = book.pageLsn.value is String
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
                  this.book.readingLsn.value=!this.book.readingLsn.value;
                  this.book.readingLsn.value ? startReading() : stopReading();
                })));
  }
}
