import 'package:aaa/pck/support/get_uid.dart';

import '../../init_fun.dart';
import 'app_data.dart';
import 'book.dart';
import 'book_mark.dart';
import 'book_state.dart';
import 'site.dart';

class Bookcase {
  //Bookcase define --------------------
  Bookcase._internal();
  static Bookcase _instance;
  static Bookcase _getInstance() => _instance ?? (_instance = Bookcase._internal());
  factory Bookcase() => _getInstance();
  static Bookcase get instance => _getInstance();
  //Bookcase define over ----------------

  //data state fn
  static get data => App.instance.bookcase["data"] ?? (App.instance.bookcase["data"] = {});
  static get state => App.instance.bookcase["state"] ?? (App.instance.bookcase["state"] = {});
  static get fn => App.instance.bookcase["fn"] ?? (App.instance.bookcase["fn"] = {});

  static Map<String, Book> get bookStore => data["bookStore"] ?? (data["bookStore"] = new Map<String, Book>());
  static Map<String, Site> get siteStore => data["siteStore"] ?? (data["siteStore"] = new Map<String, Site>());

  static deleteBook(Book book) {
    var uid = book.uid;
    book.getSite.bookBaseUrls.remove(uid);
    bookStore.remove(uid);
    saveData();
  }

  static init(List bookdata, Map sitedata, String siteUID) {
    _getInstance();
    BookMark.instance;
    for (var item in sitedata.keys) siteStore[item] = Site.fromMap(sitedata[item]);

    for (var item in bookdata) addBook(item,save: false);

    BookMark.currentBook = bookStore[bookdata[0]["uid"]];
  }

  static addBook(Map mp, {Book book, String siteUid, String bookBaseUrl, bool save: true}) {
    
    var _bk = (mp != null) ? Book.fromMap(mp) : book;
    mp = mp ?? {};
    bookStore[book?.uid ?? (_bk.uid = mp["uid"]) ?? (_bk.uid = getUid(10))] = _bk;
    BookMark.bookState[_bk.uid] = BookState(_bk, siteUid ?? mp["site"]);
    (siteStore[siteUid ?? mp["site"]])?.bookBaseUrls[_bk.uid] = bookBaseUrl ?? mp["bookBaseUrl"];

    if (save) saveData();
  }
}
