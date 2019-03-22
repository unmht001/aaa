import 'package:flutter/material.dart';
import 'package:aaa/tt1.dart';

class Page4 extends StatefulWidget {
  final Widget child;

  Page4({Key key, this.child}) : super(key: key);

  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  var _st="data";
  var _ss=[];

  @override
  Widget build(BuildContext context) {
try {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      Container(
          width: 400,
          height: 430,
          child: SdkGrid(
            ontap: (){setState(() {
              _st=_ss.toString();
            }); },
            ondown: (dt){
              _ss=[dt.globalPosition.dx,dt.globalPosition.dy];
            },
              // child: Tt1app(),
              )),
      Container(
          child: FlatButton(
        child: Text("data"),
        onPressed: () {},
      )),
      Container(
        child: Text(_st),
      )
    ]);
  } catch (e) {
    print("Page4:error \n ${e.toString()}");
    return Container(
      child: Text(e.toString()),
    );
  }
  }
}

var st="data";
