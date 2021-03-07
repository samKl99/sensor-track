import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
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
                loadingSnapshot.data) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else if (snapshot.hasData && snapshot.data.isEmpty) {
              return Center(
                child: Text("Keine gespeicherten Sensoren vorhanden"),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final sensor = snapshot.data[index];
                  return SensorListItem(
                    sensorDevice: SensorDevice(
                      id: sensor.id,
                      name: sensor.name,
                      logoURL: sensor.logoURL,
                    ),
                    onTap: () {},
                    hideTrailingIcon: true,
                  );
                },
                itemCount: snapshot.data.length,
              );
            }
          },
        );
      },
    );
  }
}
