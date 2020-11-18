import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/services/bluetooth_service.dart';

class SensorTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BluetoothService>(
          create: (_) => BluetoothService(),
        ),
      ],
      child: MaterialApp(
        title: 'Sensor Track',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
