import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SensorTrackLoadingWidget extends StatelessWidget {
  final Icon? icon;

  const SensorTrackLoadingWidget({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          icon != null ? icon! : Container(),
          const SpinKitPulse(
            color: Colors.white,
            size: 180.0,
          ),
        ],
      ),
    );
  }
}
