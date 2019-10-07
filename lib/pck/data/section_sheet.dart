import 'package:flutter/material.dart';
import '../support/chain_support.dart';
import '../support/logS.dart';
class SectionSheet extends AbstractChain<SectionSheet> {
  static Color hColor = Colors.blueAccent[100]; //高亮颜色
  static Color lColor = Colors.amber[50]; //平常颜色

  GlobalKey sgk = new GlobalKey();

  SectionSheet _father;
  SectionSheet _son;

  double get height => (sgk?.currentContext?.size?.height) ?? 0.0;
  double get sumheight => height + (father == null ? 0.0 : father.sumheight);

  String text;
  bool isHighlight = false;
  SectionSheet({this.text: "等待加载中", this.isHighlight: false});

  SectionSheet.fromMap(mp) : this.fromString(mp['text'], mp['highlight']); //获取文字
  SectionSheet.fromString(String text, [bool isHighlight = false]) : this(text: text, isHighlight: isHighlight);

  Color get cl => isHighlight ? hColor : lColor;
  changeHighlight() => isHighlight = !isHighlight;
  highLight() {
    SectionSheet _c = this;
    while (_c._father != null) (_c = _c._father).disHighLight();
    _c = this;
    while (_c._son != null) (_c = _c._son).disHighLight();
    this.isHighlight = true;
  }

  disHighLight() => isHighlight = false;
  static SectionSheet getSectionSheetChain(String text) {
    try {
      var s = text.replaceAll(new RegExp("(<[b|B][r|R]>)|(\"\t\")"), "\n").split(new RegExp(r"\n|\s\s"));
      s.removeWhere((x) => (x == " " * x.length) || x.isEmpty);
      if (s.isNotEmpty) {
        SectionSheet ch1 = SectionSheet.fromString(s[0]);
        SectionSheet ch2 = ch1;
        for (var item in s) {
          ch2.text = "  " + item;
          ch2 = ch2.born(SectionSheet());
        }
        ch2.father.son = null;
        return ch1;
      }
    } catch (e) {
      log("getSectionSheetChain error : ${e.toString()}");
    }
    return null;
  }
}