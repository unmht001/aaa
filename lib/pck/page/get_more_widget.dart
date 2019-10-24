import 'package:flutter/material.dart';

Widget getMoreWidget() {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '加载中...     ',
            style: TextStyle(fontSize: 16.0),
          ),
          CircularProgressIndicator(
            strokeWidth: 1.0,
          )
        ],
      ),
    ),
  );
}

class GetMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Padding(padding: EdgeInsets.all(10.0), child: CircularProgressIndicator(strokeWidth: 1.0)));
}
