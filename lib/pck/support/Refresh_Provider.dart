
import 'package:flutter/material.dart';

class StateStore {
  bool canSet = true;
  bool doing = false;
  List<Future> doingSetAfter = [];

  List<Function> action = [];
}

mixin RefreshProviderSTF on StatefulWidget {
  final List<Function> _lf = [() {}];
  final StateStore state = new StateStore();
  refresh() {
    _lf[0]();
  }
}
mixin RefreshProviderState<T extends RefreshProviderSTF> on State<T>  {

}