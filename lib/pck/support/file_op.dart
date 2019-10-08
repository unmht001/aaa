
import 'package:aaa/pck/data/chapter.dart';

chapterSave(Chapter cpt){

}

  // static Future<File> getSettingFile() async {
  //   try {
  //     var _pa = (await getApplicationDocumentsDirectory()).path;
  //     var _pabdjson = _pa + "/" + "bookdata" + "/" + "books.json";
  //     File _bdjfile = File(_pabdjson);
  //     if (!(await _bdjfile.exists())) await _bdjfile.create(recursive: true);
  //     if (await _bdjfile.exists()) return _bdjfile;
  //   } catch (e) {}
  //   return null;
  // }

  // static readDataFromJson() async {
  //   try {
  //     var _bdjfile = await getSettingFile();
  //     var _sdtdd = await _bdjfile.readAsString();

  //     if ((_sdtdd ?? "").isEmpty) return null;
  //     var _rds = json.decode(_sdtdd);
  //     if (_rds == null) return null;
  //     return _rds;
  //   } catch (e) {
  //     return null;
  //   }
  // }