import 'dart:async';


main(List<String> args) async{
  print("start");
  var c=Completer();
  var f=c.future;
  Future.delayed(Duration(seconds: 3)).then((x){c.complete('5');});
  print(await f);
  print("end");
  

}