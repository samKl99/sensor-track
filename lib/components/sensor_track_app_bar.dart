import 'package:flutter/material.dart';

class SensorTrackAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final Text? title;
  final List<Widget>? actions;

  SensorTrackAppBar({
    Key? key,
    this.title,
    this.actions,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      actions: actions,
    );
  }
}
