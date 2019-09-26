
// import 'package:flutter/material.dart';

// import "data_type_support.dart";

// initsdkdata() async {
//   await Future.delayed(Duration(milliseconds: 100));
//   for (var i = 0; i < 81; i++) {
//     sdkdata.add([
//       [1, 2, 3, 4, 5, 6, 7, 8, 9],
//       0,
//       false
//     ]);
//   }
//   log("sdkdata init [for] over");
//   await Future.delayed(Duration(milliseconds: 100));

//   print("sdkdata init ok");
// }

// class NoverMainPage extends StatelessWidget {
//   final Function getmenudata;
//   final Function itemonpress;
//   NoverMainPage({Key key, this.getmenudata, this.itemonpress}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: ListenerBox.instance['bks'].value.length,
//         itemBuilder: (BuildContext context, int index) => FlatButton(
//             child: Text(ListenerBox.instance['bks'].value[index].name),
//             onPressed: () {
//               ListenerBox.instance['bk'].value = ListenerBox.instance['bks'].value[index];
//               getmenudata();
//               if (itemonpress != null) itemonpress();
//             }));
//   }
// }

// class SliderC extends StatefulWidget {
//   final Function(double) fn;
//   final String label;
//   final MyListener lsn;
//   SliderC(this.label, this.lsn, {Key key, this.fn}) : super(key: key);

//   _SliderCState createState() => _SliderCState(label, fn: fn);
// }

// class _SliderCState extends State<SliderC> {
//   _SliderCState(this.label, {BuildContext context, this.fn}) : super();
//   final String label;
//   Function(double) fn;
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: <Widget>[
//       Text(label),
//       Container(
//           width: 350,
//           child: Slider(
//             value: this.widget.lsn.value,
//             onChanged: (v) {
//               this.widget.lsn.value = (v * 100).toInt() / 100;
//               setState(() {
//                 fn(this.widget.lsn.value);
//               });
//             },
//             min: 0.5,
//             max: 2,
//             divisions: 15,
//             label: '${this.widget.lsn.value}',
//           ))
//     ]);
//   }
// }

// settingPage(BuildContext context, Function(double) onchange) {
//   return ListView(children: <Widget>[
//     Container(
//       height: 50,
//     ),
//     SliderC("语速", ListenerBox.instance['speechrate'], fn: (double v) {
//       ListenerBox.instance['tts'].value.setSpeechRate(v / 2);
//       onchange(v);
//     }),
//     SliderC("语调", ListenerBox.instance['pitch'], fn: (double v) {
//       ListenerBox.instance['tts'].value.setPitch(v);
//       onchange(v);
//     }),
//     // SliderC("未用", fn: (double v) {
//     //   onchange(v);
//     // })
//   ]);
// }


