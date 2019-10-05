import 'dart:async';


class TestQueue<T> {
  TestQueue([this.max = 0]);
  List<T> _queueData = [];
  List<Completer> _getWaitList = [];
  List<Completer> _putWaitList = [];
  int max = 0;
  bool get isFull => max > 0 && _queueData.length >= max;
  bool get isNotFull => !isFull;
  bool get isEmpty => _queueData.isEmpty;
  bool get isNotEmpty => !isEmpty;

  putNoWait(T data) => _queueData.add(data);
  T getNoWait() => isNotEmpty ? _queueData.removeAt(0) : null;

  noticePut() {
    while (isNotFull && _putWaitList.isNotEmpty) _putWaitList.removeAt(0).complete();
  }

  noticeGet() {
    while (isNotEmpty && _getWaitList.isNotEmpty) _getWaitList.removeAt(0).complete(_queueData.removeAt(0));
  }

  putData(T v) async {
    if (isFull) {
      Completer c = Completer();
      _putWaitList.add(c);
      await c.future;
    }
    putNoWait(v);
    noticeGet();
  }

  Future<T> getData() async {
    T c2;
    if (isEmpty) {
      Completer c = Completer();
      _getWaitList.add(c);
      c2 = await c.future;
    } else
      c2 = getNoWait();
    noticePut();
    return c2;
  }
}

class RoadSignal {
  List<Completer> _waitList = [];
  bool _green = false;
  bool get isGreen => _green;
  flicker() {
    while (_waitList.isNotEmpty) _waitList.removeAt(0).complete();
  }

  goGreen() {
    _green = true;
    flicker();
  }

  goRed() => _green = false;

  waitGreen() async {
    if (!isGreen) {
      Completer c = new Completer();
      _waitList.add(c);
      await c.future;
    }
  }
}


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


class MyListener {
  dynamic _v = "初始";
  Function onGetter = () {};
  Function onSetter = () {};
  Function afterSetter = () {};
  bool inited = false;
  Map<String, Function> afterSetterList = {};

  // Function afterGetter=(){};
  get value {
    this.onGetter();
    return this.inited ? _v : null;
  }

  set value(var va) {
    this.onSetter();
    _v = va;
    this.inited = true;
    this.afterSetter();
  }
}