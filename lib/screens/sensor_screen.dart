import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/components/sensor_track_icon_button.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/screens/live_sensor_device_screen.dart';
import 'package:sensor_track/services/notification_service.dart';
import 'package:sensor_track/services/sensor_service.dart';

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  SensorService get _sensorService => Provider.of<SensorService>(context, listen: false);

  NotificationService get _notificationService => Provider.of<NotificationService>(context, listen: false);

  @override
  void initState() {
    _sensorService.getRegisteredSensors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _sensorService.loading,
      builder: (context, loadingSnapshot) {
        return StreamBuilder<List<Sensor>>(
          stream: _sensorService.registeredSensors,
          builder: (context, snapshot) {
            if (loadingSnapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.waiting ||
                loadingSnapshot.data != null && loadingSnapshot.data!) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: const Text("Es ist ein Fehler aufgetreten"),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: const Text("Keine gespeicherten Sensoren vorhanden"),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final sensor = snapshot.data![index];
                  return SensorListItem(
                    sensor: sensor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LiveSensorDeviceScreen(
                            sensor: sensor,
                          ),
                        ),
                      );
                    },
                    trailingWidget: _getDeleteButton(sensor),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          },
        );
      },
    );
  }

  Widget _getDeleteButton(final Sensor sensor) {
    final dialogBody = Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        const Text(
          "Sensor löschen",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        const Text("Möchtest du diesen Sensor wirklich löschen?"),
        const SizedBox(
          height: 12.0,
        ),
      ],
    );

    final onOkPressed = () async {
      try {
        await _sensorService.deleteSensor(sensor);
        _sensorService.getRegisteredSensors();
      } catch (e) {
        _notificationService.showErrorSnackBar(context, "Fehler beim Löschen");
      }
    };

    return SensorTrackIconButton(
      backgroundColor: Colors.redAccent,
      radius: 18.0,
      onPressed: () {
        _notificationService.presentWarningDialog(
          context,
          dialogBody,
          onOkPressed,
          () {},
          "Abbrechen",
          "Löschen",
        );
      },
      icon: Icon(
        Icons.delete_outline_outlined,
        color: Colors.white,
        size: 19.0,
      ),
    );
  }
}
