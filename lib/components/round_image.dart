import 'package:flutter/material.dart';

class RoundImage extends StatelessWidget {
  final String imageURL;

  const RoundImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0,
      height: 35.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 4.5,
            offset: const Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset(
          imageURL,
          fit: BoxFit.contain,
          width: 30.0,
        ),
      ),
    );
  }
}
