import 'package:flutter/material.dart';

class MaterialTesterWidget extends StatelessWidget {
  final Widget widget;

  MaterialTesterWidget({
    @required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }
}
