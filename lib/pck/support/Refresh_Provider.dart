import 'package:aaa/support.dart';
import 'package:flutter/material.dart';

class StateStore {
  bool canSet = true;
  bool doing = false;
  List<Future> doingSetAfter = [];

  List<Function> action = [];
}

mixin RefreshProviderSTF<T> on StatefulWidget {
  final List<Function> _lf = [() {}];
  final StateStore state = new StateStore();
  bool get refreshFlag=>true;
  refresh() {
    _lf[0]();
  }
  
}
mixin RefreshProviderState<T extends RefreshProviderSTF> on State<T> {
  RoadSignal rs = new RoadSignal();

  @override
  void setState(fn) {
    fn();
    rs.waitGreen().then((x) => super.setState(() {}));
  }

  refreshNoWait() {
    super.setState(() {});
  }

  refreshAsync() async {
    rs.waitGreen().then((x) => refreshNoWait());
  }
}
