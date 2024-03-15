import 'package:flutter/material.dart';

class MaterialTesterWidget extends StatelessWidget {
  final Widget widget;

  const MaterialTesterWidget({
    super.key,
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
