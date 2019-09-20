import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";

import 'package:gbk2utf8/gbk2utf8.dart';
import 'data_type_support.dart';
// import "value_listener.dart";

class PageOp {
  static charsetS(Response rp, {String charset: "utf8"}) {
    if (charset == 'gbk')
      return Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
    else if (charset == 'utf8')
      return Utf8Decoder().convert(rp.data);
    else
      return 'unknow charset : $charset';
  }

  static getpagedata(BookData book) async {
    var f=book.readingLsn.value;
    book.readingLsn.value=false;
    // print(book.uid);
    var lsn = book.pageLsn;
    try {
      assert(book.selected != null, "未选中章节");
      assert(book.menuLsn.value is List, "目录数据异常");

      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );

      lsn.value = "等待页面载入....";
      var response = await dio.get(book.bookBaseUrl + book.menuLsn.value[book.selected][0]);
      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.siteCharset).toString());
        var _ss = soup.find(id: book.contentSoupTap);
        assert(_ss != null, "没有找到页面中的结果1");

        var mch = RegExp(book.contentPatten, multiLine: true).allMatches(_ss.outerHtml);
        assert(mch.length != 0, "没有找到页面中的结果2");

        lsn.value = Beautifulsoup(mch.first.group(1).toString()).doc.body.text;
      } else
        lsn.value = "Request failed with status: ${response.statusCode}.";
    } catch (e) {
      lsn.value = "getpagedta error"+e.toString();
      print("getpage"+book.menuLsn.value[1].toString());
      return false;
    }
    if(f)book.readingLsn.value=true;
    
    return true;
  }

  static getmenudata(BookData book) async {
    print(book.uid);
    var lsn = book.menuLsn;
    try {
      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );
      lsn.value = "等待目录载入....";
      Response response = await dio.get(book.bookBaseUrl + book.menuUrl);

      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.siteCharset).toString());
        var s1 = soup(book.menuSoupTag);
        var s2 = RegExp(book.menuPattan, multiLine: true).allMatches(s1.outerHtml);
        var s12 = RegExp("<a\\shref=\"(.+?)\">(.+?)</a>", multiLine: true);
        var _r;

        assert(s2 != null, "没有找到本书");
        assert(s2.length != 0, "章节获取失败");

        lsn.value = s2
            .map((vs) => [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
            .toList();
      } else
        lsn.value = "失败代码: ${response.statusCode}.";
    } catch (e) {
      lsn.value = e.toString();
      return false;
    }
    // print(book.menuLsn.value.toString());
    return true;
  }
}
