import 'dart:convert';
import 'dart:io';

import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
import 'package:gbk2utf8/gbk2utf8.dart';

import '../support/logS.dart';
import 'book.dart';
import 'chapter.dart';
import 'site.dart';
// import 'data_type_support.dart';

class PageOp {
  static charsetS(Response rp, {String charset: "utf8"}) {
    if (charset == 'gbk')
      return Utf8Decoder().convert(unicode2utf8(gbk2unicode(rp.data)));
    else if (charset == 'utf8')
      return Utf8Decoder().convert(rp.data);
    else
      return 'unknow charset : $charset';
  }

  static String firstMatch(List firstMatchPatterns, String s) {
    if (firstMatchPatterns?.isNotEmpty ?? false)
      for (String item in firstMatchPatterns) s = RegExp(item, multiLine: true).firstMatch(s).group(1).toString();
    return s;
  }

  static List allMatch(String allMatchPattern, s) {
    if (allMatchPattern?.isNotEmpty ?? false) {
      List<RegExpMatch> s2;
      s2 = RegExp(allMatchPattern, multiLine: true).allMatches(s).toList();
      List s3 = [];
      if (s2.isNotEmpty) {
        var s4;
        for (var item in s2) {
          s4 = [];
          for (var i = 1; i <= item.groupCount; i++) s4.add(item.group(i).toString());
          s3.add(s4);
        }
        return s3;
      }
    }
    return null;
  }

  static Dio getDio(Site site) {
    bool isUtf8 = site.isRequestUtf8;
    List<int> Function(dynamic, RequestOptions) fn2 =
        (request, options) => isUtf8 ? Utf8Codec().encode(options.data) : gbk.encode(options.data);

    Dio dio = Dio(BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes, requestEncoder: fn2));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
    return dio;
  }

  static getChapterData(Chapter chapter) async {
    var r;
    var book = chapter.book;
    try {
      var url = chapter.chapterFullUrl;
      Dio dio = getDio(chapter.book.getSite);

      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.getSite.siteCharset).toString());
        var _ss = soup.find(id: book.getSite.contentSoupTap);
        assert(_ss != null, "没有找到页面中的结果1");

        var mch = RegExp(book.getSite.contentPatten, multiLine: true).allMatches(_ss.outerHtml);
        assert(mch.length != 0, "没有找到页面中的结果2");

        r = Beautifulsoup(mch.first.group(1).toString()).doc.body.text;
        r = chapter.book.name + " " + chapter.chapterName + "\n" + r;
        return r;
      } else
        r = "Request failed with status: ${response.statusCode}.";
    } catch (e) {
      r = "getpagedta error:" + e.toString();
      log("getpage:" + r);
    }
    log("getpage: over");
    return r;
  }

  static getmenudata(Book book) async {
    var _ret;
    try {
      Dio dio = getDio(book.getSite);
      _ret = "等待目录载入....";

      Response response = await dio.get(book.getMenuUrl);

      if (response.statusCode == 200) {
        var soup = Beautifulsoup(charsetS(response, charset: book.getSite.siteCharset).toString());
        var s1 = soup(book.getSite.menuSoupTag);
        var s2 = RegExp(book.getSite.menuPattan, multiLine: true).allMatches(s1.outerHtml);
        var s12 = RegExp("<a[\\s\\S]+?href=\"([\\s\\S]+?)\"[\\s\\S]*?>\\s*([\\s\\S]+?)<\/a>", multiLine: true);
        var _r;

        assert(s2 != null, "没有找到本书");
        assert(s2.length != 0, "章节获取失败");

        _ret = s2
            .map((vs) => [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
            .toList();
        // print(_ret);
      } else {
        _ret = "失败代码: ${response.statusCode}.";
        log("getmenudata 失败" + _ret.toString());
      }
    } catch (e) {
      _ret = e.toString();
      log("getmenudata error" + _ret);
    }
    return _ret;
  }

  static searchBookData(String text, Site site) async {
    var _ret;
    _ret = "等待搜索结果....";
    try {
      if (site.searchBookSetting["searchMethod"] == 'get') {
        Response response = await getDio(site).get(site.searchFullUrl(text));
        if (response.statusCode == 200) {
          var s = PageOp.charsetS(response, charset: site.siteCharset).toString();
          var s12 = RegExp("<a[\\s\\S]+?href=\"([\\s\\S]+?)\"[\\s\\S]*?>\\s*([\\s\\S]+?)<\/a>", multiLine: true);
          var _r;

          if (site.searchBookSetting["replacePattern"]?.isNotEmpty ?? false)
            for (List item in site.searchBookSetting["replacePattern"]) s = s.replaceAll(RegExp(item[0]), item[1]);

          _ret = allMatch(
                  site.searchBookSetting["allMatchPattern"], firstMatch(site.searchBookSetting["firstMatchPattern"], s))
              ?.map((vs) => [
                    (_r = s12.firstMatch(vs[0])).group(1).toString().replaceAll(site.siteBaseUrl, ""),
                    _r.group(2).toString()
                  ])
              ?.toList();
        } else
          _ret = "sitesearch:失败代码: ${response.statusCode}.";
      }
    } catch (e) {
      _ret = e.toString();
      log("sitesearch:$_ret");
    }
    return _ret;
  }
}
