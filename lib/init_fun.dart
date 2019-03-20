import 'package:aaa/data.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

checkdata() async {
  try {
    loadingtext=loadingtext+"\ngetting app dir";
    print("getting app dir");
    var _pa = (await getApplicationDocumentsDirectory()).path;
    loadingtext=loadingtext+"\napp path:$_pa";
    print("app path:$_pa");
    loadingtext=loadingtext+"\ncheck book data";
    print("check book data");
    var _paBookDataDir = _pa + "/" + "bookdata";
    var fl = Directory(_paBookDataDir);
    if (await fl.exists()) {
      loadingtext=loadingtext+"\nbook data dir ok";
      print("book data dir ok");
    } else {
      loadingtext=loadingtext+"\nbook data dir not exists,trying to create it";
      print("book data dir not exists,trying to create it");
      fl = await fl.create(recursive: true);
      if (await fl.exists()) {
        loadingtext=loadingtext+"\nbook data dir is created ok";
        print("book data dir is created ok");
      } else {
        loadingtext=loadingtext+"\nbook data dir can not be created, something wrong;";
        print("book data dir can not be created, something wrong");
        return;
      }
    }

    var _pabdjson = _paBookDataDir + "/" + "books.json";
    var _bdjfile = File(_pabdjson);
    if (await _bdjfile.exists()) {
      loadingtext=loadingtext+"\nbook data json file is found;";
      print("book data json file is found;");
    } else {
      loadingtext=loadingtext+"\nbook data json file not exist,create it";
      print("book data json file not exist,create it");
      _bdjfile = await _bdjfile.create();
      if (await _bdjfile.exists()) {
        loadingtext=loadingtext+"\nbook data json file is created";
        print("book data json file is created");
      } else {
        loadingtext=loadingtext+"\nbook data json file can not created, something wrong";
        print("book data json file can not created, something wrong");
        return;
      }
    }
    loadingtext=loadingtext+"\nreading book data json file..";
    print("reading book data json file..");
    bdlist = [];
    var _rds=json.decode(await _bdjfile.readAsString());
    if (_rds=="" || _rds==null){
      var _bdj = json.encode(bookdatapre);
      _bdjfile=await _bdjfile.writeAsString(_bdj);
      _rds=json.decode(await _bdjfile.readAsString());
      }
    for (var it in _rds) {
      bdlist.add(BookData.create(json.decode(it)));
    }
    loadingtext=loadingtext+"\nbook data is loaded, ${bdlist.length} data found";
    print("book data is loaded, ${bdlist.length} data found");
    await Future.delayed(Duration(seconds: 1));
    checkdataok = true;
  } catch (e) {
    loadingtext=loadingtext+"\n"+e.toString();
    print("something wrong ");
    print(e);
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
  print("sdkdata init [for] over");
  await Future.delayed(Duration(milliseconds: 100));

  print("sdkdata init ok");
  sdkdatainited = true;
}

init() async {
  checkdata();
  initsdkdata();
  while (!(checkdataok & sdkdatainited)) {
    print("init waiting");
    await Future.delayed(Duration(milliseconds: 400));
  }
  initok = true;
}
