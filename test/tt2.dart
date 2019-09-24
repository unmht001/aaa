import 'dart:async';
import "dart:core";

mixin A1{
  get a=>3;
  f(){
    print(a);
  }
}
class B with A1{
  B({this.a:5});
  var a;
}

main(List<String> args) {
  var _aa=[1,2,3];
  var bb=_aa.removeAt(1);
  print(bb);
  print("start");
  var a= Future.delayed(Duration(seconds: 3),(){print(333);});

  Future.sync(()=>a);
  print("end");
  B().f() ;
}