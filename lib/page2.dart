import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: Container(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          alignment: Alignment.center,
          child: Container(
            height: 100,
            color: Colors.blueAccent,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "page2.1",
                      style: TextStyle(background: () {
                        Paint _pt = new Paint();
                        _pt.color = Colors.redAccent;
                        return _pt;
                      }()),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.indigo,
                    alignment: Alignment.center,
                    child: Text(
                      "page2.2",
                      style: TextStyle(background: () {
                        Paint _pt = new Paint();
                        _pt.color = Colors.redAccent;
                        return _pt;
                      }()),
                    ),
                  ),
                ),
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "page2.3",
                      style: TextStyle(background: () {
                        Paint _pt = new Paint();
                        _pt.color = Colors.redAccent;
                        return _pt;
                      }()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
