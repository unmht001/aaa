import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mytts8/mytts8.dart';
import 'dart:io';
// import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'pck/event_gun.dart';

import 'pck/data_type_support.dart';
import 'data.dart';

log(String st ,[num tabs=0] ) {
  num t=tabs;
  print("    "*t+ st);
  Appdata.loadingtext += ("\n" +"st");
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

  static checkdata(List data) async {
    var _rds;
    try {
      log("check dir",1);
      log("getting app dir",2);
      var _pa = (await getApplicationDocumentsDirectory()).path;
      log("app path:$_pa",2);
      log("check book data",2);
      var _paBookDataDir = _pa + "/" + "bookdata";
      var fl = Directory(_paBookDataDir);
      if (await fl.exists())
        log("book data dir ok",3);
      else {
        log("book data dir not exists,trying to create it",3);
        fl = await fl.create(recursive: true);
        if (await fl.exists())
          log("book data dir is created ok",4);
        else {
          log("book data dir can not be created, something wrong",4);
          return null;
        }
      }
      // check books.json
      log("check books.json",1);
      var _pabdjson = _paBookDataDir + "/" + "books.json";
      var _bdjfile = File(_pabdjson);
      if (await _bdjfile.exists()) {
        log("book data json file is found;" ,2);
      } else {
        log("book data json file not exist,create it",2);
        _bdjfile = await _bdjfile.create();
        if (await _bdjfile.exists()) {
          log("book data json file is created",3);
        } else {
          log("book data json file can not created, something wrong",3);
          // return;
        }
      }

      //check books.json and load

      log("reading book data json file..",1);
      var bookdataList = [];
      var _sdtdd = await _bdjfile.readAsString();

      if (_sdtdd == "" || _sdtdd == null) {
        log("init bookdatapre into json file",2);
        var _bdj = jsonEncode(data);
        log("encode bookdatapre ok!",2);
        _bdjfile = await _bdjfile.writeAsString(_bdj);
        log("write data string to file ok\n try to get string from file,",2);
        _sdtdd = await _bdjfile.readAsString();
        log("read from file ok",2);
      }
      log("string length is ${_sdtdd.length}",2);
      _rds = json.decode(_sdtdd);
      log("decode string once ok!",2);
      print(_rds);
      // for (var it in _rds) {
      //   bookdataList.add(BookData.create(json.decode(it)));
      // }
      log("book data is loaded, ${bookdataList.length} data found",2);

      await Future.delayed(Duration(seconds: 1));
      // return rds;
    } catch (e) {
      log(e.toString() + "\nsomething wrong ");
      return null;
    }
    return _rds;
  }

  StateInit._internal() {
    if (StateInit._instance == null) {
      Appdata();
      Bookcase.init(Appdata.instance.bks, Appdata.instance.sitedata, "ywXSyXTKVO");

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
    var sss = await StateInit.checkdata(Appdata.instance.bks);
    if (sss != null) {
      Appdata.instance.bks = sss;
    }
    // await initsdkdata();
  }
  return true;
}
