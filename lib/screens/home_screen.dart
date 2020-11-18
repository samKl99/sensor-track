import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/services/bluetooth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    final bluetoothService = Provider.of<BluetoothService>(context)..startScan2();


    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Column(
          children: [

          ],
      ),
    );
  }
}