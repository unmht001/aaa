// import 'dart:convert';

// import 'package:url/url.dart';

// import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
// import 'dart:convert';

// import 'package:url/url.dart';

main(List<String> args) {
  // var a = Url.parse("http://www.shumil.co/search.php?searchtype=all&searchkey=%C9%CF%BB%A2&sbt=%CB%D1%CB%F7");
  Map m={
    "searchtype":"all",
    "searchkey":"上虎",
    "sbt":"搜索"
  };
  List a=[];
  for (var item in m.keys.toList()) {
    a.add("$item=${Uri.encodeQueryComponent(m[item],encoding: gbk)}");   
  }
  var b="http://www.shumil.co/search.php";
  print(b+"?"+a.join("&"));
  
  // var dio=Dio();
  // dio.post(path)
  // print(Uri.encodeQueryComponent("http://www.shumil.co/search.php?searchtype=all&searchkey=上虎&sbt=搜索",encoding: gbk));
}
