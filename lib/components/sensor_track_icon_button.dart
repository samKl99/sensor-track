import 'package:flutter/material.dart';

class SensorTrackIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Color? backgroundColor;
  final double? radius;
  final bool loading;
  final Color? loadingColor;

  const SensorTrackIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.radius,
    this.loading = false,
    this.loadingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: IconButton(
        icon: loading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? Colors.white),
                strokeWidth: 2.0,
              )
            : icon,
        onPressed: loading ? () {} : onPressed,
      ),
    );
  }
}
