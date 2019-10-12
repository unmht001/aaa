import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'patten_test.dart';

// import "package:http/http.dart" as http;

// import 'package:http/io_client.dart';

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

  var b = "https://sou.xanbhx.com/search?siteid=kenwencom&q=地球";
  var _ret;
  _ret = "等待目录载入....";
  try {
    Dio dio = new Dio(
      BaseOptions(contentType: ContentType.html, responseType: ResponseType.bytes, requestEncoder: fn2),
    );

    // var url = b + "?" + ll.join("&");
    var url = b;
    print(url);
    // var url = "http://www.shumil.co/search.php?all&searchkey=%B5%D8%C7%F2&sbt=%CB%D1%CB%F7";

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      var s = charsetS(response, charset: "utf8").toString();
      // s = s.replaceAll(RegExp("(</b>)|(<b>)"), "");
      // s = RegExp("<div\\sclass=\"list\">([\\S\\s]+?)<div\\sclass=\"clear\">", multiLine: true)
      //     .firstMatch(s)
      //     .group(1)
      //     .toString();
      var s2 = RegExp(
              "(?:<li>(?:[\\s\\S]+?)(?:<span\\sclass=\"s2\">(?!<b>)([\\s\\S]*?)(?!<\/b>)<\/span>[\\s]+?)(?:[\\s\\S]+?)<\/li>)",
              multiLine: true)
          .allMatches(s)
          .toList()
          .map((x) => x.group(1).toString())
          .toList();
      // print(s2);
      // var s2=["<a href=\"http://www.kenwen.com/cview/236/236169/\" target=\"_blank\">                            地球妖精</a>                    ]"];
      // var s12 = RegExp("<([\\s\\S]+?)", multiLine: true);
      // _ret=s12.firstMatch( s2[0]).group(1).toString();
      var s12 = RegExp("<a[\\s\\S]+?href=\"([\\s\\S]+?)\"[\\s\\S]+?>\\s*([\\s\\S]+?)<\/a>", multiLine: true);
      var _r;
      _ret = s2
          .map((vs) => [
                (_r = s12.firstMatch(vs)).group(1).toString().replaceAll("http://www.kenwen.com/", ""),
                _r.group(2).toString()
              ])
          .toList();
    } else
      _ret = "失败代码: ${response.statusCode}.";
  } catch (e) {
    _ret = e.toString();
  }
  print(_ret);
}

main(List<String> args) {
// var replaceAll = "http://www.kenwen.com//a//b//c//d".replaceAll(RegExp( r"""(?:[^:])//""" , "/"));
// print(replaceAll);

  // fn1();
}
