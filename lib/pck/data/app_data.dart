// import 'd_s_f_w.dart';


import '../../support.dart' show Dsfw;

class App with Dsfw {
  static String logString="";
  static App _instance;
  App._internal();
  static App _getInstance() => _instance ?? (_instance = App._internal());
  factory App() => _getInstance();
  static App get instance => _getInstance();

  static Map _database = {};
  @override
  Map get database => _database;
  get bookmark => data["bookmark"] ?? (data["bookmark"] = {});
  // set bookmark(v) => data["bookmark"] = v;

  get appState => state["appState"] ?? (state["appState"] = {});
  // set appState(v) => state["appState"] = v;

  get bookcase => data["bookcase"] ?? (data["bookcase"] = {});
  // set bookcase(v) => data["bookcase"] = v;
}
