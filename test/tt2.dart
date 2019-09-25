import 'dart:async';
import "dart:core";

// import 'package:flutter/material.dart';

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





abstract class D1<T>{
  T a;

}


class D2<T extends D1> extends D1<T> {

  T get b=>a;
  set b(T v)=>a=v;

  T d2(){
    return this as T;
  }

  @override
  String toString() {
    
    return "d2";
  }
}

class D3 extends D2<D3> {}


main(List<String> args) {
  var _aa=[1,2,3];
  var bb=_aa.removeAt(1);
  print(bb);
  print("start");
  var a= Future.delayed(Duration(seconds: 3),(){print(333);});

  Future.sync(()=>a);
  print("end");
  B().f() ;

  var c=D3();
  
  print( c.d2() is D3 );

}