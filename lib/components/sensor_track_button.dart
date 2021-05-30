import 'package:flutter/material.dart';

class SensorTrackButton extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Color? color;
  final bool? loading;
  final Widget? icon;

  const SensorTrackButton({
    Key? key,
    this.text,
    this.onPressed,
    this.color,
    this.textStyle,
    this.loading,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          color ?? Theme.of(context).buttonColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(16.0),
        ),
      ),
      onPressed: onPressed,
      child: loading != null && loading!
          ? const SizedBox(
              height: 25.0,
              width: 25.0,
              child: const Center(
                child: const CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                Text(
                  text ?? "",
                  style: textStyle,
                ),
              ],
            ),
    );
  }
}
