
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'patten_test.dart';

List<int> fn2(request, RequestOptions options) {
  return gbk.encode(options.data);
}

fn1() async {
  Map m = {"searchtype": "all", "searchkey": "三十年", "sbt": "搜索"};
  var ll = [];
  for (var item in m.keys.toList()) {
    m[item] = Uri.encodeQueryComponent(m[item], encoding: gbk);
    ll.add("$item=${m[item]}");
  }

  var b = "http://www.shumil.co/search.php";
  var _ret;
  _ret = "等待目录载入....";
  try {
    Dio dio = new Dio(
      BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes, requestEncoder: fn2),
    );

    var url = b + "?" + ll.join("&");
    print(url);
    // var url = "http://www.shumil.co/search.php?all&searchkey=%B5%D8%C7%F2&sbt=%CB%D1%CB%F7";

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      var s = charsetS(response, charset: "gbk").toString();
      s = s.replaceAll(RegExp("(</b>)|(<b>)"), "");
      s = RegExp("<div\\sclass=\"list\">([\\S\\s]+?)<div\\sclass=\"clear\">", multiLine: true)
          .firstMatch(s)
          .group(1)
          .toString();
      var s2 = RegExp("<li>([\\S\\s]+?)</li>", multiLine: true).allMatches(s);
      var s12 = RegExp("<a[\\s\\S]+?href=\"(.+?)\">(.+?)</a>", multiLine: true);
      var _r;
      _ret = s2
          .toList()
          .map((vs) => [(_r = s12.firstMatch(vs.group(1).toString())).group(1).toString(), _r.group(2).toString()])
          .toList();
    } else
      _ret = "失败代码: ${response.statusCode}.";
  } catch (e) {
    _ret = e.toString();
  }
  print(_ret);
}

main(List<String> args) {
  fn1();
}
