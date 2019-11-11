// import '../support/app_data.dart';
import '../../support.dart';
import 'app_data.dart';
import 'book.dart';
import 'book_state.dart';

class BookMark {
  //factory
  BookMark._internal();
  static BookMark _instance;
  static BookMark _getInstance() => _instance ?? (_instance = BookMark._internal());
  factory BookMark() => _getInstance();
  static Map<String, BookState> bookState = {};
  static BookMark get instance => _getInstance();

  //data state fn
  static get data => App.instance.bookmark["data"] ?? (App.instance.bookmark["data"] = {});
  static get state => App.instance.bookmark["state"] ?? (App.instance.bookmark["state"] = {});
  static get fn => App.instance.bookmark["fn"] ?? (App.instance.bookmark["fn"] = {});

  //currentBook
  static Book get currentBook => data["currentBook"];
  static set currentBook(Book v) {
    data["currentBook"] = v;
    currentBookAfterSetterForMenu(v);
    currentBookAfterSetterForPage(v);
  }

  static get currentBookAfterSetterForMenu =>
      fn["currentBookAfterSetterForMenu"] ?? (fn["currentBookAfterSetterForMenu"] = ([x]) {});
  static set currentBookAfterSetterForMenu(Function v) => fn["currentBookAfterSetterForMenu"] = v;
  static get currentBookAfterSetterForPage =>
      fn["currentBookAfterSetterForPage"] ?? (fn["currentBookAfterSetterForPage"] = ([x]) {});
  static set currentBookAfterSetterForPage(Function v) => fn["currentBookAfterSetterForPage"] = v;

  //state
  static get chapterPageRefresher => fn["chapterPageRefresher"] ?? ([x]) {};
  static set chapterPageRefresher(Function v) => fn["chapterPageRefresher"] = v;

  static bool get chapterPageNeedToRefresh =>
      state["chapterPageNeedToRefresh"] ?? (state["chapterPageNeedToRefresh"] = false);
  static set chapterPageNeedToRefresh(bool v) {
    state["chapterPageNeedToRefresh"] = v;
    log("chapterPageRefresher Action");
    chapterPageRefresher(v);
  }

  static get menuPageRefresher => fn["menuPageRefresher"] ?? ([x]) {};
  static set menuPageRefresher(Function v) => fn["menuPageRefresher"] = v;
  static bool get menuPageNeedToRefresh => state["menuPageNeedToRefresh"] ?? (state["menuPageNeedToRefresh"] = false);
  static set menuPageNeedToRefresh(bool v) {
    state["menuPageNeedToRefresh"] = v;
    menuPageRefresher(v);
  }

  static bool get menuPageIsWaitingRefresh =>
      state["menuPageIsWaitingRefresh"] ?? (state["menuPageIsWaitingRefresh"] = false);
  static set menuPageIsWaitingRefresh(bool v) => state["menuPageIsWaitingRefresh"] = v;

  static Future get menuPageFuture => data["menuPageFuture"] ?? (data["menuPageFuture"] = null);
  static set menuPageFuture(Future v) => data["menuPageFuture"] = v;

  static get onAppToTop => fn["onAppToTop"] ?? (fn["onAppToTop"] = ([x]) {});
  static set onAppToTop(Function v) => fn["onAppToTop"] = v;

  static RoadSignal get chapterRefreshRs => data["chapterRefreshRs"] ?? (data["chapterRefreshRs"] = new RoadSignal());

  static get mainPageRefresher => fn["mainPageRefresher"] ?? (fn["mainPageRefresher"] = ([x]) {});
  static set mainPageRefresher(Function v) => fn["mainPageRefresher"] = v;


  static RoadSignal get menuRs =>state["menuRs"]??(state["menuRs"]= new RoadSignal());
  static  set menuRs( RoadSignal v)=>state["menuRs"]=v;
  static RoadSignal get chapterRs =>state["chapterRs"]??(state["chapterRs"]= new RoadSignal());
  static  set chapterRs( RoadSignal v)=>state["chapterRs"]=v;


}
