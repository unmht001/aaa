
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
  // final List<Function> _lf = [() {}];
  // static int _count = 0;
  // @override
  // void initState() {
  //   super.initState();
  //   // this.widget._lf[0] = () => setState(() {});
  // }

  // @override
  // void dispose() {
  //   this.widget._lf[0] = () {};
  //   super.dispose();
  // }


  // _setState() async {
  //   print("start setState ${this.widget.state.action.length} ");
  //   try {
  //     RefreshProviderState._count += 1;
  //     print("${RefreshProviderState._count.toString()}:${this.widget.state.action.length}:${this.widget.state.doing}");
  //   } catch (e) {
  //     print(e);
  //   }

  //   while (this.widget.state.action.isNotEmpty) {
  //     this.widget.state.doing = true;

  //     await Future.value((this.widget.state.action.removeAt(0))());
  //     this.widget.state.doing = false;
  //   }

  //   if (this.widget.state.action.isEmpty && !this.widget.state.doing && this.mounted) super.setState(() {});
  // }

  // @override
  // setState(fn) {
  //   this.widget.state.action.add(fn);
  //   if (this.widget.state.canSet) {
  //     this.widget.state.canSet = false;
  //     _setState().then((x) {
  //       this.widget.state.canSet = true;
  //     });
  //   } else {
  //     print("已经开始setState,此次加入等待");
  //   }
  // }
}