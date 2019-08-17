import 'package:aaa/data.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import './pck/data_type_support.dart';
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
    checkdataok = true;
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
  sdkdatainited = true;
}

init() async {
  StateInit();
  checkdata();
  initsdkdata();
  while (!(checkdataok & sdkdatainited)) {
    log("init waiting");
    await Future.delayed(Duration(milliseconds: 400));
  }
  initok = true;
}
