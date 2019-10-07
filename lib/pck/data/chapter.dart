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
  bool isloaded = false;
  bool isloading = false;

  List<Chapter> get menu => book?.menu;
  Chapter([this.chapterUrl = "", this.chapterName = "", this.book]);
  Chapter.fromList(List lst) {
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

  initContent() async {
    if (!isloading) {
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
}
