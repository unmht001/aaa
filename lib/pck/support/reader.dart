import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import '../../data_type.dart';
import 'logS.dart';

mixin Reader on StatefulWidget {
  Chapter get chapter;
  set chapter(Chapter v);
  Book get book => chapter.book;
  Mytts8 get tts => gettts();
  static gettts() => Appdata.instance.tts;
}

mixin ReaderState<T extends Reader> on State<T> {
  Book get book => this.widget.book;
  bool get isReadingMode;
  SectionSheet get currentHL;
  set currentHL(SectionSheet ss);

  Mytts8 get tts => this.widget.tts;
  pagemove([SectionSheet sss]);
  markRefresh();
  refresh([Function fn]);

  continueReading() async {
    if (await tts.isLanguageAvailable('zh-CN'))
      refresh(() {
        tts.setCompletionHandler(() => refresh(() async {
              if (currentHL.son != null) {
                currentHL = currentHL.son;
                pagemove(currentHL);
                continueReading();
                if (checkState()) refresh();
              } else
                changeChapter(-1.0);
            }));
        if (book.getBookstate.isreading) this.widget.tts.speak(currentHL.text);
      });
    else
      print('language is not available');
  }

  startReading() async {
    if (isReadingMode) {
      book.getBookstate.isreading = true;
      continueReading();
    }
  }

  stopReading() async {
    book.getBookstate.isreading = false;
    tts.stop();
  }

  smartReading([SectionSheet ss]) async {
    if (ss != null) {
      currentHL = ss;
      checkState();
      refresh();
    }

    book.getBookstate.isreading = !book.getBookstate.isreading;
    book.getBookstate.isreading ? continueReading() : tts.stop();
  }

  loadChapter() async {
    await this.widget.chapter.initContent();
    currentHL = book.getBookstate.currentChapter.contentStart;
    await startReading();
    log("loadChapter refresh");
    refresh();
    pagemove();
  }

  changeChapter(double v) {
    log("changeChapter");
    this.widget.chapter =
        (v < 0 ? this.widget.chapter.son : v > 0 ? this.widget.chapter.father : null) ?? this.widget.chapter;
    checkState();
    log("changeChapter markRefresh");
    markRefresh();
  }

  checkState() {
    log("checkState");
    bool f = false;
    if (this.widget.chapter?.isloaded ?? false) {
      log("checkState:本章节已经加载");
      if (currentHL == null || currentHL.first != this.widget.chapter.contentStart) {
        log("checkState:高亮显示段落", 1);
        currentHL = this.widget.chapter.contentStart;
      }

      currentHL.highLight();
      f = true;
    } else if (!(this.widget.chapter?.isloading ?? true)) {
      log("checkState:章节未加载, 启动加载");
      loadChapter();
    } else {
      log("checkState:章节加载中");
    }
    return f;
  }
}
