import '../../data_type.dart' show App;

log(var st, [num tabs = 0]) {
  (App.instance.appState["data"] ?? (App.instance.appState["data"] = {}))["loadingtext"] = st.toString();
  App.logString += "\n" + "    " * tabs + st.toString();
  print("    " * tabs + st.toString());
}
