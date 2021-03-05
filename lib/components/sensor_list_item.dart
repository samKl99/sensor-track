import 'package:flutter/material.dart';
import 'package:sensor_track/models/sensor_device.dart';

class SensorListItem extends StatelessWidget {
  final SensorDevice sensorDevice;

  const SensorListItem(this.sensorDevice);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(sensorDevice.name ?? "Keine Name vorhanden"),
          Text(sensorDevice.rssi.toString() ?? "-"),
        ],
      ),
    );
  }
}
