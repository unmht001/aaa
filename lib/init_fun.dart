import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'pck/data_type_support.dart';
import 'data.dart';

log(String st) {
  print(st);
  loadingtext += ("\n" + "st");
}

checkdata() async {
  try {
    log("getting app dir");
    var _pa = (await getApplicationDocumentsDirectory()).path;
    log("app path:$_pa");
    log("check book data");
    var _paBookDataDir = _pa + "/" + "bookdata";
    var fl = Directory(_paBookDataDir);
    if (await fl.exists()) {
      log("book data dir ok");
    } else {
      log("book data dir not exists,trying to create it");
      fl = await fl.create(recursive: true);
      if (await fl.exists()) {
        log("book data dir is created ok");
      } else {
        log("book data dir can not be created, something wrong");
        return;
      }
    }

    var _pabdjson = _paBookDataDir + "/" + "books.json";
    var _bdjfile = File(_pabdjson);
    if (await _bdjfile.exists()) {
      log("book data json file is found;");
    } else {
      log("book data json file not exist,create it");
      _bdjfile = await _bdjfile.create();
      if (await _bdjfile.exists()) {
        log("book data json file is created");
      } else {
        log("book data json file can not created, something wrong");
        return;
      }
    }
    log("reading book data json file..");
    bdlist = [];
    var _sdtdd = await _bdjfile.readAsString();

    if (_sdtdd == "" || _sdtdd == null) {
      log("init bookdatapre into json file");
      var _bdj = json.encode(ListenerBox.instance['bks'].value);
      log("encode bookdatapre ok!");
      _bdjfile = await _bdjfile.writeAsString(_bdj);
      log("write data string to file ok\n try to get string from file,");
      _sdtdd = await _bdjfile.readAsString();
      log("read from file ok");
    }
    log("string length is ${_sdtdd.length}");
    var _rds = json.decode(_sdtdd);
    log("decode string once ok!");
    for (var it in _rds) {
      bdlist.add(BookData.create(json.decode(it)));
    }
    log("book data is loaded, ${bdlist.length} data found");

    await Future.delayed(Duration(seconds: 1));
  } catch (e) {
    log(e.toString() + "\nsomething wrong ");
  }
}

initsdkdata() async {
  await Future.delayed(Duration(milliseconds: 100));
  for (var i = 0; i < 81; i++) {
    sdkdata.add([
      [1, 2, 3, 4, 5, 6, 7, 8, 9],
      0,
      false
    ]);
  }
  log("sdkdata init [for] over");
  await Future.delayed(Duration(milliseconds: 100));

  print("sdkdata init ok");
}

class StateInit {
  static StateInit _instance;
  static StateInit get instance => _instance ?? new StateInit._internal();
  factory StateInit() => _instance ?? new StateInit._internal();
  static bool _inited = false;
  static get inited => _inited;
  static Function afterinit;
  static set inited(bool value) {
    _inited = value;
    afterinit();
  }

  StateInit._internal() {
    if (StateInit._instance == null) {
      var bks = [
        {
          "id": 1,
          "name": "剑来",
          "bookBaseUrl": "jianlai/",
          "author": "烽火戏诸侯",
          "uid": "RrnyYWAzzT",
          "site": "ywXSyXTKVO"
        },
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
        {
          "id": 5,
          "name": "第一序列",
          "bookBaseUrl": "dixulie/",
          "author": "不知道",
          "uid": "altdlfEtGl",
          "site": "ywXSyXTKVO"
        },
        {
          "id": 6,
          "name": "明朝败家子",
          "bookBaseUrl": "mingchaobaijiazi/",
          "author": "不知道",
          "uid": "LVHOSKvvCb",
          "site": "ywXSyXTKVO"
        },
      ];

      Map sitedata = {
        "ywXSyXTKVO": {
          "siteUID": "ywXSyXTKVO",
          "siteName": "书迷楼",
          "siteBaseUrl": "http://www.shumil.co/",
          "menuUrl": "index.html",
          "menuSoupTag": "div.content",
          "menuPattan": "(<li.+?/li>)",
          "siteCharset": 'gbk',
          "contentPatten": "</div>[^>]+?(<p>[\\s\\S]+?</p>)",
          "contentSoupTap": '#content',
        }
      };

      Bookcase.init(bks, sitedata, "ywXSyXTKVO");
      // BookMark.currentBook=

      // ListenerBox.instance['bk'].value = bks[0];
      // ListenerBox.instance['bks'].value = bks;
      ListenerBox.instance['isreading'].value = false;
      ListenerBox.instance['cpLoaded'].value = false;
      ListenerBox.instance['tts'].value = Mytts8();
      ListenerBox.instance['speechrate'].value = 1.5;
      ListenerBox.instance['pitch'].value = 0.8;
      ListenerBox.instance['navs'].value = [
        NavData("书架", Icons.book),
        NavData("精选", Icons.bookmark),
        NavData("发现", Icons.search),
        NavData("我", Icons.person)
      ];
      inited = true;
    }
  }
}

init(EventGun ff) async {
  await Future.delayed(Duration(seconds: 1));

  if (StateInit.inited) {
    return true;
  } else {
    while (true) {
      Future.delayed(Duration(seconds: 1), () => StateInit());
      // if (ff.isFired) ff = new EventGun();
      StateInit.afterinit = ff.fire;
      await ff.waitFire();
      if (StateInit.inited)
        break;
      else
        StateInit();
    }
    await checkdata();
    await initsdkdata();
  }
  return true;
}
