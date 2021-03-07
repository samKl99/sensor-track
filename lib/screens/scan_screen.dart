import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_list_item.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';
import 'package:tinycolor/tinycolor.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  BluetoothService _bluetoothService;

  @override
  void initState() {
    _bluetoothService = Provider.of<BluetoothService>(context, listen: false)..startScan();
    super.initState();
  }

  @override
  void dispose() {
    _bluetoothService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorService = Provider.of<SensorService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scannen"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TinyColor.fromString("#2c2e3d").color,
      ),
      body: StreamBuilder<bool>(
        stream: _bluetoothService.searching,
        builder: (context, searchingSnapshot) {
          return StreamBuilder<List<SensorDevice>>(
            stream: _bluetoothService.sensorDevices,
            builder: (context, snapshot) {
              if (searchingSnapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  searchingSnapshot.data) {
                return _buildBluetoothDevicesSearchingWidget();
              } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                final sensorDevices = snapshot.data;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final sensorDevice = sensorDevices[index];
                    return SensorListItem(
                      sensorDevice: sensorDevice,
                      onTap: () async {
                        if (sensorService.isSensorPersisted(sensorDevice.id)) {
                          sensorService.deleteSensorById(sensorDevice.id);
                          setState(() {
                            sensorDevice.persisted = false;
                          });
                        } else {
                          sensorService.addSensor(sensorDevice);
                          setState(() {
                            sensorDevice.persisted = true;
                          });
                        }
                        // refresh sensors
                        sensorService.getSavedSensors();
                      },
                    );
                  },
                  itemCount: sensorDevices.length,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Fehler"),
                );
              } else {
                return Center(
                  child: Text("Keine Sensoren vorhanden"),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBluetoothDevicesSearchingWidget() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            color: secondaryColor,
            size: 40.0,
          ),
          SpinKitPulse(
            color: Colors.white,
            size: 180.0,
          ),
        ],
      ),
    );
  }
}
