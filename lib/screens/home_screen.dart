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
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Übersicht"),
        centerTitle: true,
      ),
      body: Column(
          children: [
          ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          bluetoothService.startScan();
        },
        icon: Icon(Icons.bluetooth_searching),
        label: Text("Scannen"),
      ),
    );
  }
}