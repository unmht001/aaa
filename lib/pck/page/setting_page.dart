import "package:flutter/material.dart";
import '../../data_type.dart';
class ContentSettingPageData {
  static Site csite;
  static Book _cbk;
  static Book get cbk => (_cbk?.getSite != csite) ? null : _cbk;
  static set cbk(Book bk) => _cbk = bk;
  static getSiteMapFromIndex(int index) => Appdata.instance.sitedata[(Appdata.instance.sitedata.keys.toList())[index]];
  static getBooksFromSiteUid(String uid) {
    var sm = Appdata.instance.sitedata[uid];
    if (sm == null) return null;
    List bks = [];
    for (var v in Bookcase.bookStore.values) {
      if (v.getSite.siteUID == uid) bks.add(v);
    }
    return bks;
  }

  static double get w1 => 100;
  static double get w2 => (Appdata.width ?? 440) - 40 - w1;
  static double get h1 => 30;
  static double get h2 => ((Appdata.height ?? 680) - 40 - h1 * 2 - 90) / 2;

  static Function bookListRefresh;
  static Function siteDetailRefresh;
  static Function bookDetailRefresh;
}

class ContentSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: ListView(children: <Widget>[
          Container(
              color: Colors.brown[200],
              height: ContentSettingPageData.h1,
              child: FlatButton(onPressed: () {}, child: Text("保存设置"))),
          Row(children: <Widget>[
            Container(
                width: ContentSettingPageData.w1,
                height: ContentSettingPageData.h2,
                color: Colors.green[100],
                child: SiteListView()),
            Container(
                width: ContentSettingPageData.w2,
                height: ContentSettingPageData.h2,
                color: Colors.yellow[100],
                child: SiteDetailView())
          ]),
          Row(children: <Widget>[
            Container(
                width: ContentSettingPageData.w1,
                height: ContentSettingPageData.h2,
                color: Colors.red[100],
                child: _BookListView()),
            Container(
                width: ContentSettingPageData.w2,
                height: ContentSettingPageData.h2,
                color: Colors.yellow[100],
                child: Bookdetailview())
          ]),
          Row(children: <Widget>[
            Container(
                color: Colors.blue[50],
                height: ContentSettingPageData.h1,
                child: FlatButton(onPressed: () {}, child: Text("正则测试页")))
          ])
        ]));
  }
}

class SiteListView extends StatefulWidget {
  @override
  _SiteListViewState createState() => _SiteListViewState();
}

class _SiteListViewState extends State<SiteListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Appdata.instance.sitedata.length,
        itemBuilder: (context, index) {
          return FlatButton(
              onPressed: () {
                ContentSettingPageData.csite = Bookcase.siteStore[(Appdata.instance.sitedata.keys.toList())[index]];
                (ContentSettingPageData.bookListRefresh ?? () {})();
                (ContentSettingPageData.siteDetailRefresh ?? () {})();
                (ContentSettingPageData.bookDetailRefresh ?? () {})();
              },
              child: Container(
                  color: Colors.green[300],
                  padding: EdgeInsets.all(3),
                  child: Text(ContentSettingPageData.getSiteMapFromIndex(index)["siteName"], softWrap: true)));
        });
  }
}

class _BookListView extends StatefulWidget {
  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<_BookListView> {
  @override
  void initState() {
    super.initState();
    ContentSettingPageData.bookListRefresh = () => setState(() {});
  }

  @override
  void dispose() {
    ContentSettingPageData.bookListRefresh = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ContentSettingPageData.csite == null) return ListView();
    List bks = ContentSettingPageData.getBooksFromSiteUid(ContentSettingPageData.csite.siteUID);
    if (bks == null || bks.isEmpty) {
      return ListView();
    }
    return ListView.builder(
        itemCount: bks.length,
        itemBuilder: (context, index) => FlatButton(
            onPressed: () {
              ContentSettingPageData.cbk = (bks[index] as Book);
              (ContentSettingPageData.bookDetailRefresh ?? () {})();
            },
            child: Text((bks[index] as Book)?.name.toString(), softWrap: true)));
  }
}

class SiteDetailView extends StatefulWidget {
  @override
  _SiteDetailViewState createState() => _SiteDetailViewState();
}

class _SiteDetailViewState extends State<SiteDetailView> {
  @override
  void initState() {
    super.initState();
    ContentSettingPageData.siteDetailRefresh = () => setState(() {});
  }

  @override
  void dispose() {
    ContentSettingPageData.siteDetailRefresh = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ss = ContentSettingPageData.csite;
    if (ss == null) return ListView();
    var ss2 = ss.toMap();
    var keys = ss2.keys.toList();
    Widget aall;
    return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          var aavalue = ss2[keys[index]];
          // print(keys[index]);
          var aastring;
          if (aavalue == null)
            aastring = "null";
          else if (keys[index] == "bookBaseUrls") {
            List<Widget> aall_2 = [];
            for (var x in aavalue.keys) {
              aall_2.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Container(child: Text(x.toString())),
                Container(child: Text(aavalue[x].toString()))
              ]));
            }
            aall = Column(children: aall_2);
          } else
            aastring = aavalue.toString();
          return Column(children: <Widget>[
            Container(alignment: Alignment(-1, 0), color: Colors.blue[50], child: Text(keys[index], softWrap: true)),
            Container(
                alignment: Alignment(1, 0),
                color: Colors.purple[100],
                child: (keys[index] == "bookBaseUrls") ? aall : Text(aastring, softWrap: true))
          ]);
        });
  }
}

class Bookdetailview extends StatefulWidget {
  @override
  _BookdetailviewState createState() => _BookdetailviewState();
}

class _BookdetailviewState extends State<Bookdetailview> {
  @override
  void initState() {
    super.initState();
    ContentSettingPageData.bookDetailRefresh = () => setState(() {});
  }

  @override
  void dispose() {
    ContentSettingPageData.bookDetailRefresh = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ss = ContentSettingPageData.cbk;
    if (ss == null) return ListView();
    var ss2 = ss.toMap();
    var keys = ss2.keys.toList();
    return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          var aavalue = ss2[keys[index]];
          var aastring = aavalue.toString();
          return Column(children: <Widget>[
            Container(alignment: Alignment(-1, 0), color: Colors.blue[50], child: Text(keys[index], softWrap: true)),
            Container(alignment: Alignment(1, 0), color: Colors.purple[100], child: Text(aastring, softWrap: true))
          ]);
        });
  }
}
