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

log(String st, [num tabs = 0]) {
  num t = tabs;
  print("    " * t + st);
  Appdata.loadingtext += ("\n" + "st");
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

  static Future<File> getSettingFile() async {
    try {
      var _pa = (await getApplicationDocumentsDirectory()).path;
      var _pabdjson = _pa + "/" + "bookdata" + "/" + "books.json";
      File _bdjfile = File(_pabdjson);
      if (!(await _bdjfile.exists())) await _bdjfile.create(recursive: true);
      if (await _bdjfile.exists()) return _bdjfile;
    } catch (e) {}
    return null;
  }

  static readDataFromJson() async {
    try {
      var _bdjfile = await getSettingFile();
      var _sdtdd = await _bdjfile.readAsString();

      if ((_sdtdd ?? "").isEmpty) return null;
      var _rds = json.decode(_sdtdd);
      if (_rds == null) return null;
      return _rds;
    } catch (e) {
      return null;
    }
  }

  static readDataFromDefault() async => getDefault();

  static readDataFromSetting() async => {"bookdata": Appdata.instance.bks, "sitedata": Appdata.instance.sitedata};

  static saveDataToJson(data) async {
    try {
      var _bdjfile = await getSettingFile();

      String d2 = jsonEncode(data);
      await _bdjfile.writeAsString(d2, mode: FileMode.write);
      return true;
    } catch (e) {
      return false;
    }
  }

  static checkdata(List data) async {
    var _rds;
    try {
      var _bdjfile = await getSettingFile();

      log("reading book data json file..", 1);
      var bookdataList = [];
      var _sdtdd = await _bdjfile.readAsString();

      if (_sdtdd == "" || _sdtdd == null) {
        log("init bookdatapre into json file", 2);
        var _bdj = jsonEncode(data);
        log("encode bookdatapre ok!", 2);
        _bdjfile = await _bdjfile.writeAsString(_bdj, mode: FileMode.write);
        log("write data string to file ok\n try to get string from file,", 2);
        _sdtdd = await _bdjfile.readAsString();
        log("read from file ok", 2);
      }
      log("string length is ${_sdtdd.length}", 2);
      _rds = json.decode(_sdtdd);
      log("decode string once ok!", 2);
      print(_rds);
      // for (var it in _rds) {
      //   bookdataList.add(BookData.create(json.decode(it)));
      // }
      log("book data is loaded, ${bookdataList.length} data found", 2);

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
    var sss = await StateInit.readDataFromJson();
    bool flag = false;
    if (sss == null) {
      sss = StateInit.readDataFromDefault();
      flag = true;
    }
    Appdata.instance.bks = sss["bookdata"];
    Appdata.instance.sitedata = sss["sitedata"];
    if (flag) await StateInit.saveDataToJson(sss);

    while (true) {
      Future.delayed(Duration(seconds: 1), () => StateInit());
      StateInit.afterinit = ff.fire;
      await ff.waitFire();
      if (StateInit.inited)
        break;
      else
        StateInit();
    }
    // var sss = await StateInit.checkdata(Appdata.instance.bks);

    // await initsdkdata();
  }
  return true;
}
