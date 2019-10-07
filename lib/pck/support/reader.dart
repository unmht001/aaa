import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import '../../data_type.dart';
import 'logS.dart';

mixin Reader on StatefulWidget {
  Chapter get chapter;
  Book get book;
  Mytts8 get tts => gettts();
  static gettts() => Appdata.instance.tts;
}

mixin ReaderState<T extends Reader> on State<T> {
  Book get book => this.widget.book;

  SectionSheet get currentHL => book.getBookstate.currentHL;
  set currentHL(SectionSheet ss) => book.getBookstate.currentHL = ss;

  // get onChapterReadingOver => book.getBookstate.onChapterReadingOver;
  // set onChapterReadingOver(Function fn) => book.getBookstate.onChapterReadingOver = fn;

  Mytts8 get tts => this.widget.tts;
  pagemove([SectionSheet sss]);

  refresh([Function fn]);

  continueReading() async {
    if (await tts.isLanguageAvailable('zh-CN'))
      refresh(() {
        tts.setCompletionHandler(() => refresh(() async {
              if (currentHL.son != null) {
                currentHL = currentHL.son;
                pagemove(currentHL);
                continueReading();
                checkState();
              } else
                changeChapter(1.0);
            }));
        if (book.getBookstate.isreading) this.widget.tts.speak(currentHL.text);
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

  smartReading() async {
    book.getBookstate.isreading = !book.getBookstate.isreading;
    book.getBookstate.isreading ? continueReading() : tts.stop();
  }

  loadChapter() async {
    log("toNextChapter");
    await this.widget.chapter.initContent();
    currentHL = book.getBookstate.currentChapter.contentStart;
    await (Appdata.isReadingMode ? startReading : () async {})();
    refresh();
    if (!Appdata.isAppOnBack) pagemove();
  }

  changeChapter(double v) {
    num f1 = BookMark.currentBook.getBookstate.currentChapter.index;
    num f2 = BookMark.currentBook.menu.length;
    num f3 = (v < 0 && f1 < f2 - 1) ? 1 : (v > 0 && f1 > 1) ? -1 : null;
    if (f3 != null) BookMark.currentBook.getBookstate.currentChapter = BookMark.currentBook.menu[f1 + f3];
    log("chapter index: " + BookMark.currentBook.getBookstate.currentChapter.index.toString());
    BookMark.menuPageNeedToRefresh = true;
    BookMark.chapterPageNeedToRefresh = true;
  }

  checkState() {
    log("checkState:start");
    bool f = false;
    if (this.widget.chapter.isloaded) {
      log("checkState:本章节已经加载");
      if (currentHL == null || currentHL.first != this.widget.chapter.contentStart) {
        log("checkState:高亮显示段落", 1);
        currentHL = this.widget.chapter.contentStart;
        f = true;
      }
      if (!currentHL.isHighlight) {
        currentHL.highLight();
        f = true;
      } else {
        currentHL.highLight();
      }
    } else if (!this.widget.chapter.isloading) {
      log("checkState:章节未加载, 启动加载");
      loadChapter().then((x) => refresh());
    } else {
      log("checkState:章节加载中");
    }
    return f;
  }
}
