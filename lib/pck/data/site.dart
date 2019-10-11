import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

import 'book.dart';
import 'get_string.dart';

class Site {
  String siteName;
  String siteBaseUrl;
  String siteUID;
  String menuUrl;
  String menuSoupTag;
  String menuPattan;
  String siteCharset;
  String contentSoupTap;
  String contentPatten;
  num drop = 0;
  Map<String, String> bookBaseUrls = {};
  Map searchBookSetting = {
    "requestCoding": "",
    "searchUrl": "",
    "queryMask": "",
    "replacePattern": [],
    "firstMatchPattern": [],
    "allMatchPattern": "",
    "searchMethod": "get",
    "urlReplaceSymbol": "<--replace-->"
  };
  Site.fromMap(Map mp) {
    this.siteName = mp["siteName"];
    this.siteBaseUrl = mp["siteBaseUrl"];
    this.siteUID = mp["siteUID"];
    this.menuUrl = mp["menuUrl"];
    this.menuSoupTag = mp["menuSoupTag"];
    this.menuPattan = mp["menuPattan"];
    this.siteCharset = mp["siteCharset"];
    this.contentSoupTap = mp["contentSoupTap"];
    this.contentPatten = mp["contentPatten"];
    this.drop = mp["drop"] ?? 0;
    this.searchBookSetting = mp["searchBookSetting"];
  }
  toMap() => {
        "siteName": this.siteName,
        "siteUID": this.siteUID,
        "siteBaseUrl": this.siteBaseUrl,
        "menuUrl": this.menuUrl,
        "menuSoupTag": this.menuSoupTag,
        "menuPattan": this.menuPattan,
        "siteCharset": this.siteCharset,
        "contentSoupTap": this.contentSoupTap,
        "contentPatten": this.contentPatten,
        "bookBaseUrls": this.bookBaseUrls,
        "drop": this.drop,
        "searchBookSetting": this.searchBookSetting
      };
  toString() => toMap.toString();

  addBook(Book book, String bookBaseUrl) {
    bookBaseUrls[book.uid] = bookBaseUrl;
  }

  searchBook(String text) async {
    var _ret;
    _ret = "等待目录载入....";
    try {
      bool isUtf8 =
          (((searchBookSetting["requestCoding"] == null || searchBookSetting["requestCoding"].toString().isEmpty)
                  ? siteCharset
                  : searchBookSetting["requestCoding"])) ==
              "utf8";
      if (searchBookSetting["urlNeadCoding"] == "true")
        text = Uri.encodeQueryComponent(text, encoding: isUtf8 ? Utf8Codec() : gbk);

      List<int> Function(dynamic, RequestOptions) fn2 =
          (request, options) => isUtf8 ? Utf8Codec().encode(options.data) : gbk.encode(options.data);

      if (searchBookSetting["searchMethod"] == 'get') {
        String url = searchBookSetting["searchUrl"].toString().replaceAll(searchBookSetting["urlReplaceSymbol"], text);
        Dio dio =
            Dio(BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes, requestEncoder: fn2));
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        };

        Response response = await dio.get(url);
        if (response.statusCode == 200) {
          var s = PageOp.charsetS(response, charset: siteCharset).toString();
          var s12 = RegExp("<a[\\s\\S]+?href=\"([\\s\\S]+?)\"[\\s\\S]*?>\\s*([\\s\\S]+?)<\/a>", multiLine: true);
          var _r;
          List s2;
          if (searchBookSetting["replacePattern"]?.isNotEmpty ?? false)
            for (List item in searchBookSetting["replacePattern"]) s = s.replaceAll(RegExp(item[0]), item[1]);
          if (searchBookSetting["firstMatchPattern"]?.isNotEmpty ?? false)
            for (String item in searchBookSetting["firstMatchPattern"])
              s = RegExp(item, multiLine: true).firstMatch(s).group(1).toString();
          s2 = RegExp(searchBookSetting["allMatchPattern"], multiLine: true).allMatches(s).toList();
          s2 = s2.map((vs) => vs.group(1).toString()).toList();
          _ret = s2
              .map((vs) =>
                  [(_r = s12.firstMatch(vs)).group(1).toString().replaceAll(siteBaseUrl, ""), _r.group(2).toString()])
              .toList();
        } else
          _ret = "失败代码: ${response.statusCode}.";
      }
    } catch (e) {
      _ret = e.toString();
    }
    // print(_ret);
    return _ret;
  }
}
