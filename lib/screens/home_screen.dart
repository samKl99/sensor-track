import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/scan_card_item.dart';
import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:tinycolor/tinycolor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScanService _scanService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scanService = Provider.of<ScanService>(context, listen: false)..getLastScans();
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Letzte Scans"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TinyColor.fromString("#2c2e3d").color,
      ),
      body: StreamBuilder<bool>(
        stream: _scanService.scansLoading,
        builder: (context, loadingSnapshot) {
          return StreamBuilder<List<Scan>>(
            stream: _scanService.scans,
            builder: (context, snapshot) {
              if (loadingSnapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  loadingSnapshot.data) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                    snapshot.data.length,
                    (index) => ScanCardItem(snapshot.data[index]),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              } else {
                return Center(
                  child: Text(
                    "Keine letzten Scans verfügbar",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //bluetoothService.startScan();
          /*
          _scanService.addScan(
            Scan(
              temperature: 30.7,
              humidity: 23.1,
              pressure: 1753,
              createdAt: DateTime.now(),
              sensorDeviceName: "Sensor 1",
              sensorDeviceLogoURL: "assets/sensor-icons/ruuvi.png",
            ),
          );
           */
        },
        icon: Icon(Icons.bluetooth_searching),
        label: Text("Scannen"),
      ),
    );
  }
}
