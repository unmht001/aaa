import "dart:core";

// import 'dart:ffi';

mixin Aaa{
  fly(){
    print("Aaa is flying");
  }
  
}
class B1 with Aaa{

  @override
  fly() {
    var r=super.fly();
    print("B1 is flying");
    return r;
  }

}

class B2 extends B1 with Aaa{

  @override
  fly() {
    print("B2 is fly fastest");
    return super.fly();
  }
}


main(List<String> args) {
  var b=B2();
  b.fly();
}