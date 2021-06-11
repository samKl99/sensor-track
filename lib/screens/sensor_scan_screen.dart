import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/components/sensor_track_app_bar.dart';
import 'package:sensor_track/screens/sensor_track_create_device_screen.dart';
import 'package:sensor_track/components/sensor_track_loading_widget.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SensorService sensorService = Provider.of<SensorService>(context, listen: false)..searchSensors();

    return Scaffold(
      appBar: SensorTrackAppBar(
        title: const Text("Scannen"),
      ),
      body: StreamBuilder<bool>(
        stream: sensorService.searching,
        builder: (context, searchingSnapshot) {
          return StreamBuilder<List<Sensor>>(
            stream: sensorService.sensors,
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
                      trailingWidget: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 19.0,
                        child: IconButton(
                          onPressed: () {
                            _registerOnDataMarketplace(context, sensorService, sensorDevice);
                          },
                          color: Colors.white,
                          icon: Icon(
                            Icons.add,
                            size: 19.0,
                          ),
                        ),
                      ),
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

  _registerOnDataMarketplace(final BuildContext context, final SensorService sensorService, final Sensor sensor) async {
    sensorService.stopSearchingSensors();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SensorTrackCreateDeviceScreen(
          sensor: sensor,
        ),
      ),
    );
  }
}
