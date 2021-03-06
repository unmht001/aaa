import '../../support.dart';
import 'book_mark.dart';
import 'book_state.dart';
import 'bookcase.dart';
import 'chapter.dart';
import 'get_string.dart';
import 'site.dart';

class Book {
  String name;
  // String bookBaseUrl;
  num id;
  String author;
  String pic;
  String progress;
  String state;
  String lastupdatetime;
  String lastupdatepagename;
  String uid;

  saveToLocal(){}
  readFromLocal(){}


  toMap() {
    return {
      "id": this.id,
      "uid": this.uid,
      "author": this.author,
      "pic": this.pic,
      "progress": this.progress,
      "state": this.state,
      "name":this.name,
      "lastupdatepagename": this.lastupdatepagename,
      "lastupdatetime": this.lastupdatetime,
      "bookBaseUrl":getSite.bookBaseUrls[uid]??"",
      "site":getSite?.siteUID ??""
    };
  }

  toString() {
    return toMap().toString();
  }

  // String site;

  List<Chapter> menu = [];

  initMenu(List<List<String>> lm) {
    
    menu = [];
    var i = 0;
    var lm2;
    log("initMenu: drop: ${this.getSite.drop}");
    if(lm.length>this.getSite.drop){
      lm2=lm.getRange(this.getSite.drop, lm.length);
    }else{
      lm2=lm;
    }
    for (var item in lm2) {
      menu.add(Chapter(item[0], item[1], this));
      menu.last.index = i;
      i++;
    }
    for (var i = 0; i < menu.length - 1; i++) {
      menu[i].son = menu[i + 1];
    }
  }

  Book(this.id, this.name, this.author, this.uid) {
    menu.add(Chapter(null, null, this));
  }
  Book.fromMap(Map bookdata) : this(bookdata["id"], bookdata["name"], bookdata["author"], bookdata["uid"]);
  getMenu() async {
    var a = await PageOp.getmenudata(this);
    if (a is String)
      return false;
    else
      this.initMenu(a);
    getBookstate.isMenuLoaded = true;
    return true;
  }

  // getContent(Chapter chapter) async => await PageOp.getpagedata(this, chapter);
  BookState get getBookstate => BookMark.bookState[this.uid];
  Site get getSite => Bookcase.siteStore[getBookstate.siteString];
  String get getMenuUrl => (getSite.siteBaseUrl + "/"+ getSite.bookBaseUrls[uid] +"/"+ getSite.menuUrl).replaceAll(RegExp( "//" ), "/").replaceAll(RegExp( ":/" ), "://");
  double get getMenuPv => getBookstate.menupv;
  // setMenuPv()=>getBookstate.menupv

}
