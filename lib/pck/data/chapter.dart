// import 'dart:convert';

import 'package:aaa/support.dart';

import 'get_string.dart';
import 'section_sheet.dart';
import 'book.dart';

class Chapter extends AbstractChain<Chapter> {
  String content = "等待加载中";
  SectionSheet baseSectionSheet = new SectionSheet();
  SectionSheet _contentStart;
  SectionSheet get contentStart {
    if (isloaded) {
      assert(_contentStart != null);
      return _contentStart;
    } else
      return baseSectionSheet;
  }

  set contentStart(SectionSheet sectionSheet) => _contentStart = sectionSheet;

  String chapterUrl;
  String chapterName;
  Book book;

  int index;
  bool isloaded ;
  RoadSignal s = new RoadSignal();

  //isloading true=red, false=greed
  bool get isloading => s.isRed;  
  set isloading(bool value) => (value ? s.goRed() : s.goGreen())==RoadColor.RED;

  String chapterUid;
  bool localSaved = false;

  toMap() {
    return {
      "chapterUid": this.chapterUid,
      "chapterUrl": this.chapterUrl,
      "chapterName": this.chapterName,
      "book": this.book.uid,
      "father": this.father?.chapterUid,
      "son": this.son?.chapterUid,
      "content": this.content,
    };
  }

  save() {
    // String text=jsonEncode(toMap());
  }

  fromMap(mp) {}

  List<Chapter> get menu => book?.menu;
  Chapter([this.chapterUrl = "", this.chapterName = "", this.book, this.chapterUid]) {
    isloading = false;
    isloaded = false;
  }
  Chapter.fromList(List lst) {
    isloaded=false;
    isloaded=false;
    if (lst != null) {
      this.chapterUrl = lst[0][0];
      this.chapterName = lst[0][1];
      List lst2 = lst.getRange(1, lst.length);
      if (lst2.isNotEmpty) this.son = Chapter.fromList(lst2);
    } else {
      this.chapterUrl = "";
      this.chapterName = "";
    }
  }
  String get chapterFullUrl => (book.getSite.siteBaseUrl + book.getSite.bookBaseUrls[book.uid] + chapterUrl)
      .replaceAll("//", "/")
      .replaceAll(RegExp(":/"), "://");

  waitLoadOver() async {
    if (isloading) {
      await s.waitRed();
    }
  }

  loadChapterContent() async {
    if (!isloaded && !isloading) {
      isloading = true;
      if (book != null) {
        content = await PageOp.getChapterData(this);
        contentStart = SectionSheet.getSectionSheetChain(content.toString());
        contentStart.highLight();
        isloaded = true;
        isloading = false;
        return true;
      } else
        isloading = false;
      return false;
    }
    return true;
  }

  initContent() async {
    await loadChapterContent();
    if (son != null) await son.loadChapterContent();

    return true;
  }
}
