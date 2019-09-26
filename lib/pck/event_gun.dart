
//todo: 写一个dart 的 类似 python 的 async.event
import 'dart:async';

class EventGun {
  bool isFired = false;
  bool isWaiting = false;

  Completer _completer = new Completer();

  Future waitFire() {
    if (this._completer.isCompleted) throw AppException("Gun is destroyed");
    if (this.isFired) throw AppException("Gun is fired");
    if (this.isWaiting) throw AppException("Gun is on some waiting ");
    this.isWaiting = true;
    return this._completer.future;
  }

  fire([arg]) {
    if (this._completer.isCompleted) throw AppException("Gun is destroyed");
    if (this.isFired) throw AppException("Gun is fired");
    if (!this.isWaiting) throw AppException("Gun is not waiting ");
    this.isWaiting = false;
    this.isFired = false;
    this._completer.complete(arg);
  }
}

class AppException implements Exception {
  final String message;
  const AppException([this.message]);
  String toString() => message ?? 'AppException';
}