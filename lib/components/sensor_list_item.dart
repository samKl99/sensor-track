import 'package:flutter/material.dart';
import 'package:sensor_track/components/round_image.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/style/style.dart';

class SensorListItem extends StatelessWidget {
  final Sensor sensor;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const SensorListItem({
    required this.sensor,
    this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: primaryColorLight,
        borderRadius: BorderRadius.circular(18.0),
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6.5,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          sensor.name ?? "Kein Name vorhanden",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        subtitle: sensor.iotaDeviceData != null
            ? Text(
                sensor.iotaDeviceData!.sensorId ?? "",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : null,
        onTap: onTap,
        leading: sensor.logoURL != null ? RoundImage(sensor.logoURL!) : null,
        trailing: trailingWidget,
      ),
    );
  }
}
