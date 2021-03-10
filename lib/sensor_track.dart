import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/screens/splash_screen.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';

class SensorTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<HiveScanRepository>(
          initialData: null,
          create: (_) async => HiveScanRepository().init(),
          lazy: false,
        ),
        FutureProvider<HiveSensorRepository>(
          initialData: null,
          create: (_) async => HiveSensorRepository().init(),
          lazy: false,
        ),
        ProxyProvider<HiveScanRepository, ScanService>(
          update: (context, repository, _) => ScanService(repository),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider<HiveSensorRepository, SensorService>(
          update: (context, repository, _) => SensorService(repository),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider<SensorService, BluetoothService>(
          update: (context, sensorService, _) => BluetoothService(sensorService),
          dispose: (context, service) => service.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Sensor Track',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: primaryColor,
          accentColor: secondaryColor,
          primaryColor: primaryColor,
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme.copyWith(
                  bodyText2: TextStyle(color: Colors.white),
                  bodyText1: TextStyle(color: Colors.white),
                ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: secondaryColor,
          ),
          buttonTheme: ButtonThemeData(buttonColor: secondaryColor),
        ),
        home: Consumer2<HiveScanRepository, HiveSensorRepository>(
          builder: (context, scanRepository, sensorRepository, widget) {
            if (scanRepository == null || sensorRepository == null) {
              return SplashScreen();
            } else {
              return HomeScreen();
            }
          },
        ),
      ),
    );
  }
}
