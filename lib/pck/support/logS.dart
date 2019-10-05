import 'package:aaa/pck/support/app_data.dart';

log(var st, [num tabs = 0]) {
  (App.instance.appState["data"] ?? (App.instance.appState["data"] = {}))["loadingtext"] = st.toString();
  App.logString += "\n" + "    " * tabs + st.toString();
  print("    "*tabs+st.toString());
}
