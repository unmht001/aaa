import 'dart:async';

import 'dart:math';


String getUid(int length) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  int strlenght = length;
  String left = '';
  for (var i = 0; i < strlenght; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
main(List<String> args) async{
  print("start");
  var c=Completer();
  var f=c.future;
  Future.delayed(Duration(seconds: 3)).then((x){c.complete('5');});
  print(await f);
  print("end");
  
  for (var i = 0; i < 10; i++) {
    print(getUid(10));
    
  }

}