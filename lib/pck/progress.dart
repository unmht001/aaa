import "package:flutter/material.dart";
class ProgressValue {
  double _value = 0.0;
  num max = 100.0;
  double offset=0;
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
  final ProgressValue value;
  final Color color;
  final double padding;
  final gk = GlobalKey();
  ProgressDragger(this.value,
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
            onTapUp: (detail) => setState(() {
              if (this.mounted){
                  this.widget.value.value = detail.localPosition.dx *
                      this.widget.value.max /
                      (context.size.width - (this.widget.padding ?? 0) * 2);
                  if (this.widget.onTapUp != null) this.widget.onTapUp(detail);}
                }),
            onVerticalDragUpdate: (detail) => setState(() {
              if (this.mounted){
                  this.widget.value.value = detail.localPosition.dx *
                      this.widget.value.max /
                      (context.size.width - (this.widget.padding ?? 0) * 2);
                  if (this.widget.onVerticalDragUpdate != null) this.widget.onVerticalDragUpdate(detail);}
                }),
            child: new LinearProgressIndicator(
                value: this.widget.value.value / this.widget.value.max,
                backgroundColor: Colors.yellow,
                valueColor: this.widget.valueColor)));
  }
}
