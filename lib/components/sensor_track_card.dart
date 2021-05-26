import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class SensorTrackCard extends StatelessWidget {
  final Widget child;
  final double? minHeight;
  final VoidCallback? onTap;

  const SensorTrackCard({
    Key? key,
    required this.child,
    this.minHeight,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight ?? 100),
        child: Container(
          decoration: BoxDecoration(
            color: TinyColor.fromString("#35374a").color,
            borderRadius: BorderRadius.circular(25.0),
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 6.5,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
