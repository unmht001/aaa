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

  static getChapterData(Chapter chapter) async {
    var r;
    var book=chapter.book;
    try {
      var url = book.getSite.siteBaseUrl + book.getSite.bookBaseUrls[book.uid] + chapter.chapterUrl;
      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );

      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.getSite.siteCharset).toString());
        var _ss = soup.find(id: book.getSite.contentSoupTap);
        assert(_ss != null, "没有找到页面中的结果1");

        var mch = RegExp(book.getSite.contentPatten, multiLine: true).allMatches(_ss.outerHtml);
        assert(mch.length != 0, "没有找到页面中的结果2");

        r = Beautifulsoup(mch.first.group(1).toString()).doc.body.text;
        r=chapter.book.name+ " "+ chapter.chapterName+"\n"+r;
        return r;
      } else
        r = "Request failed with status: ${response.statusCode}.";
    } catch (e) {
      r = "getpagedta error" + e.toString();
      print("getpage" + r);
    }
    return r;
  }

  static getmenudata(Book book) async {
    var _ret;
    try {
      Dio dio = new Dio(
        BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes),
      );
      _ret = "等待目录载入....";

      Response response = await dio.get(book.getMenuUrl);

      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.getSite.siteCharset).toString());
        var s1 = soup(book.getSite.menuSoupTag);
        var s2 = RegExp(book.getSite.menuPattan, multiLine: true).allMatches(s1.outerHtml);
        var s12 = RegExp("<a\\shref=\"(.+?)\">(.+?)</a>", multiLine: true);
        var _r;

        assert(s2 != null, "没有找到本书");
        assert(s2.length != 0, "章节获取失败");

        _ret = s2
            .map((vs) => [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
            .toList();
      } else
        _ret = "失败代码: ${response.statusCode}.";
    } catch (e) {
      _ret = e.toString();
    }
    return _ret;
  }
}
