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
