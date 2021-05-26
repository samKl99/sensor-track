import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/components/sensor_track_app_bar.dart';
import 'package:sensor_track/components/sensor_track_loading_widget.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late SensorService _sensorService;

  @override
  void initState() {
    _sensorService = Provider.of<SensorService>(context, listen: false)..searchSensors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sensorService = Provider.of<SensorService>(context);

    return Scaffold(
      appBar: SensorTrackAppBar(
        title: const Text("Scannen"),
      ),
      body: StreamBuilder<bool>(
        stream: _sensorService.searching,
        builder: (context, searchingSnapshot) {
          return StreamBuilder<List<Sensor>>(
            stream: _sensorService.sensors,
            builder: (context, snapshot) {
              if (searchingSnapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  searchingSnapshot.data != null && searchingSnapshot.data!) {
                return bluetoothDevicesSearchingWidget;
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final sensorDevices = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final sensorDevice = sensorDevices[index];
                    return SensorListItem(
                      sensor: sensorDevice,
                      onTap: () async {
                        if (await sensorService.isSensorPersisted(sensorDevice.id)) {
                          await sensorService.deleteSensorById(sensorDevice.id!);
                          setState(() {
                            sensorDevice.persisted = false;
                          });
                        } else {
                          await sensorService.addSensor(sensorDevice);
                          setState(() {
                            sensorDevice.persisted = true;
                          });
                        }
                      },
                    );
                  },
                  itemCount: sensorDevices.length,
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: const Text("Es ist ein Fehler aufgetreten"),
                );
              } else {
                return const Center(
                  child: const Text("Keine Sensoren vorhanden"),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget get bluetoothDevicesSearchingWidget {
    return SensorTrackLoadingWidget(
      icon: Icon(
        Icons.bluetooth_searching,
        color: secondaryColor,
        size: 40.0,
      ),
    );
  }

  @override
  void dispose() async {
    // refresh sensors
    _sensorService.getSavedSensors();

    _sensorService.stopSearchingSensors();
    super.dispose();
  }
}
