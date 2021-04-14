import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/screens/live_sensor_device_screen.dart';
import 'package:sensor_track/services/sensor_service.dart';

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  @override
  Widget build(BuildContext context) {
    final sensorService = Provider.of<SensorService>(context)..getSavedSensors();

    return StreamBuilder<bool>(
      stream: sensorService.loading,
      builder: (context, loadingSnapshot) {
        return StreamBuilder<List<Sensor>>(
          stream: sensorService.sensors,
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
                    hideTrailingIcon: true,
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
}
