import 'package:flutter/material.dart';

class DirectSelectItem extends StatelessWidget {
  final String title;
  final bool isForList;

  DirectSelectItem({this.title, this.isForList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: isForList
            ? Padding(
                child: _buildItem(context),
                padding: EdgeInsets.all(10),
              )
            : Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    _buildItem(context),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_drop_down),
                    )
                  ],
                ),
              ));
  }

  Container _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
