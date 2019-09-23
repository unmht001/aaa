import 'dart:async';
import "dart:core";



main(List<String> args) {
  print("start");
  var a= Future.delayed(Duration(seconds: 3),(){print(333);});

  Future.sync(()=>a);
  print("end");
}