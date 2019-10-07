import 'package:aaa/pck/data/section_sheet.dart';

import 'book.dart';
import 'chapter.dart';

class BookState {
  String siteString;
  Book book;
  double menupv = 1.0;
  static double menuOffset;
  double pagepv = 1.0;
  static double contentOffset;
  Chapter currentChapter;


  BookState(this.book, this.siteString);
  bool isreading = false;
  bool isMenuLoaded = false;

  SectionSheet currentHL;
  Function onChapterReadingOver;
  

}
