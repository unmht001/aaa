import 'dart:convert';


main(List<String> args) {
  var bks = [
    {"id": 1, "name": "剑来", "bookBaseUrl": "jianlai/", "author": "烽火戏诸侯", "uid": "RrnyYWAzzT", "site": "ywXSyXTKVO"},
    {
      "id": 2,
      "name": "还是地球人狠",
      "bookBaseUrl": "huanshidiqiurenhen/",
      "author": "不知道",
      "uid": "xAMgaXwYoL",
      "site": "ywXSyXTKVO"
    },
    {
      "id": 3,
      "name": "星辰之主",
      "bookBaseUrl": "xingchenzhizhu/",
      "author": "减肥专家",
      "uid": "dwmuEMQmPw",
      "site": "ywXSyXTKVO"
    },
    {
      "id": 4,
      "name": "黎明之剑",
      "bookBaseUrl": "limingzhijian/",
      "author": "大眼珠子",
      "uid": "BkXSEJlnaM",
      "site": "ywXSyXTKVO"
    },
    {"id": 5, "name": "第一序列", "bookBaseUrl": "dixulie/", "author": "不知道", "uid": "altdlfEtGl", "site": "ywXSyXTKVO"},
    {
      "id": 6,
      "name": "明朝败家子",
      "bookBaseUrl": "mingchaobaijiazi/",
      "author": "不知道",
      "uid": "LVHOSKvvCb",
      "site": "ywXSyXTKVO"
    },
  ];


  print("*"*5);
  var m=jsonEncode(bks); 
  print(m.runtimeType);
  print(m);
  // var j=jsonDecode(m,);
  // print(j.runtimeType);
  // print("${j.runtimeType}, \n $j , \n ${j[0].runtimeType}, \n ${j[0]} ");

}
