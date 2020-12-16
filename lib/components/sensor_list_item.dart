import 'package:flutter/material.dart';

class SensorListItem extends StatelessWidget {
  final String sensorName;

  const SensorListItem({this.sensorName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(this.sensorName ?? "")
        ],
      ),
    );
  }
}
