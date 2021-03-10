import 'package:flutter/material.dart';
import 'package:sensor_track/components/round_image.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/style/style.dart';

class SensorListItem extends StatelessWidget {
  final SensorDevice sensorDevice;
  final bool hideTrailingIcon;
  final VoidCallback onTap;

  const SensorListItem({this.sensorDevice, this.onTap, this.hideTrailingIcon = false});

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
          sensorDevice.name ?? "Kein Name vorhanden",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        leading: RoundImage(sensorDevice.logoURL),
        trailing: !hideTrailingIcon
            ? IconButton(
                icon: sensorDevice.persisted != null && sensorDevice.persisted
                    ? Icon(
                        Icons.star_rounded,
                        color: Theme.of(context).accentColor,
                        size: 28.0,
                      )
                    : Icon(
                        Icons.star_border_rounded,
                        color: Colors.white,
                        size: 28.0,
                      ),
                onPressed: onTap,
              )
            : null,
      ),
    );
  }
}
