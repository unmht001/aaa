import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
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

  bool get isRequestUtf8 =>
      ((searchBookSetting["requestCoding"] == null || searchBookSetting["requestCoding"].toString().isEmpty)
          ? siteCharset
          : searchBookSetting["requestCoding"]) ==
      "utf8";

  addBook(Book book, String bookBaseUrl) {
    bookBaseUrls[book.uid] = bookBaseUrl;
  }

  String searchFullUrl(String text) => searchBookSetting["searchUrl"].toString().replaceAll(
      searchBookSetting["urlReplaceSymbol"],
      searchBookSetting["urlNeadCoding"] == "true"
          ? Uri.encodeQueryComponent(text, encoding: isRequestUtf8 ? Utf8Codec() : gbk)
          : text);

  searchBook(String text) async => PageOp.searchBookData(text, this);
}
