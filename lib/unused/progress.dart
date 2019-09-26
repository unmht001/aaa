import "package:flutter/material.dart";

class ProgressValue {
  double _value = 0.0;
  num max = 100.0;

  double _offset = 1.0;
  double get offset => _offset;
  set offset(double offset) {
    _offset = offset < 0 ? 0 : offset > 1 ? 1.0 : offset;
  }

  double get value => _value;
  set value(num v) => _value = (v == null || v < 0) ? 0.0 : v > max ? max : v.toDouble();
  ProgressValue([num v, this.max])
      : assert(max > 0),
        assert(v <= max) {
    this.value = v;
  }
}

class ProgressDragger extends StatefulWidget {
  final Decoration decoration;
  final Function(TapUpDetails) onTapUp;
  final Function(DragUpdateDetails) onVerticalDragUpdate;
  final Animation<Color> valueColor;
  final double heigh;
  final double width;
  final ScrollController controller;
  final Color color;
  final double padding;
  final gk = GlobalKey();
  ProgressDragger(this.controller,
      {Key key,
      this.onTapUp,
      this.onVerticalDragUpdate,
      this.valueColor,
      this.heigh,
      this.width,
      this.color,
      this.padding,
      this.decoration})
      : super(key: key);
  @override
  _ProgressDraggerState createState() => _ProgressDraggerState();
}

class _ProgressDraggerState extends State<ProgressDragger> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollPosition get p => this.widget.controller.position;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.all(this.widget.padding ?? 0),
        height: this.widget.heigh,
        width: this.widget.width,
        color: this.widget.color,
        decoration: this.widget.decoration,
        child: GestureDetector(
            onTapUp: (detail) => setState(() => this.widget.controller.animateTo(
                (detail.localPosition.dx / (context.size.width - (this.widget.padding ?? 0) * 2)) *
                        (p.maxScrollExtent - p.minScrollExtent) +
                    p.minScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease)),
            onVerticalDragUpdate: (detail) => setState(() => this.widget.controller.animateTo(
                (detail.localPosition.dx / (context.size.width - (this.widget.padding ?? 0) * 2)) *
                        (p.maxScrollExtent - p.minScrollExtent) +
                    p.minScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease)),
            child: new LinearProgressIndicator(
                value: (p.pixels - p.minScrollExtent) / (p.maxScrollExtent - p.minScrollExtent),
                backgroundColor: Colors.yellow,
                valueColor: this.widget.valueColor)));
  }
}
