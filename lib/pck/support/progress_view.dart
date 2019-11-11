import 'package:flutter/material.dart';

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ViewTest(
//           itemCount: 50,
//           onLoading: () async {
//             print("onload action......");
//             await Future.delayed(Duration(seconds: 2));
//             print("onLoad action over");
//             return true;
//           },
//           itemBuilder: (context, id) => Container(child: Text(id.toString()))),
//     );
//   }
// }

enum LoadingState {
  OnTop,
  OnLoading,
  OnWaiting,
}

class ViewTest extends StatefulWidget {
  final ScrollController controller;
  final Future<bool> Function() onLoading;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  ViewTest({this.controller, this.itemCount, this.itemBuilder, this.onLoading});

  @override
  _ViewTestState createState() => _ViewTestState();
}

class _ViewTestState extends State<ViewTest> with SingleTickerProviderStateMixin {
  // ScrollController ctr;
  AnimationController actr;
  Animation<double> ani;

  @override
  void initState() {
    super.initState();
    // ctr = new ScrollController(initialScrollOffset: 1);
    actr = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    actr.addListener(() => setState(() {}));
    ani = Tween<double>(begin: 0.0, end: 80.0).animate(actr);
  }

  @override
  void dispose() {
    // ctr.dispose();
    actr.dispose();
    super.dispose();
  }

  GestureDragUpdateCallback onDragUpdate = (DragUpdateDetails detail) {};
  GestureTapUpCallback onTapUp;
  DateTime t1;
  LoadingState state = LoadingState.OnWaiting;
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: (ScrollNotification notification) {
          double offset = notification.metrics.pixels;
          LoadingState st = state;

          if (offset == 0) {
            if (state == LoadingState.OnWaiting) {
              state = LoadingState.OnTop;
              // print("onTop");
            } else if (state == LoadingState.OnTop) {
              state = LoadingState.OnLoading;
              // print("onLoading");
            }
          } else if (offset == notification.metrics.maxScrollExtent) {
          } else {
            if (state == LoadingState.OnTop) {
              state = LoadingState.OnWaiting;
            }
          }
          if (state == LoadingState.OnLoading && st != state)
            () async {
              if (this.widget.onLoading == null) {
                state = LoadingState.OnWaiting;
              } else {
                actr.reset();
                actr.forward();
                await this.widget.onLoading();
                actr.reverse();
                state = LoadingState.OnWaiting;
              }
            }();

          return true;
        },
        child: Stack(children: <Widget>[
          Positioned(
              left: 0,
              right: 30,
              top: 0,
              bottom: 0,
              child: Container(
                  // color: Colors.yellow,
                  child: ListView.builder(
                      controller: this.widget.controller,
                      itemCount: this.widget.itemCount + 1,
                      itemBuilder: (context, id) => (id == 0)
                          ? Container(
                              height: ani.value,
                              child:Center( child: new CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                  backgroundColor: Colors.blue,
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))))
                          : this.widget.itemBuilder(context, id - 1)))),
          Positioned(width: 30, right: 0, top: 0, bottom: 0, child: TB(controller: this.widget.controller))
        ]));
  }
}

class TB extends StatefulWidget {
  final ScrollController controller;
  final Color backColor;
  final Color foreColor;
  TB({Key key, this.controller, this.backColor = Colors.white, this.foreColor = Colors.blue}) : super(key: key);
  @override
  _TBState createState() => _TBState();
}

class _TBState extends State<TB> {
  double get factor {
    double value = (this.widget.controller?.position?.maxScrollExtent ?? 1);
    value = value == 0 ? 1 : value;
    value = (this.widget.controller?.offset ?? 0) / value;

    return value < 0 ? 0 : value > 1 ? 1 : value;
  }
  @override
  void initState() {
    super.initState();
    this.widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails detail) {
          double value = detail.localPosition.dy / context.size.height;
          value = value < 0 ? 0 : value > 1 ? 1 : value;
          this.widget.controller.jumpTo(value * this.widget.controller.position.maxScrollExtent);
          setState(() {});
        },
        onTapUp: (TapUpDetails detail) {
          double value = detail.localPosition.dy / context.size.height;
          value = value < 0 ? 0 : value > 1 ? 1 : value;
          this.widget.controller.jumpTo(value * this.widget.controller.position.maxScrollExtent);
          
          context.findRenderObject().markNeedsLayout();
          setState(() {});
        },
        child: Container(
            color: this.widget.backColor,
            child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: factor ?? 0,
                alignment: Alignment.topCenter,
                child: Container(color: this.widget.foreColor))));
  }
}
