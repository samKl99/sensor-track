import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/screens/splash_screen.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:tinycolor/tinycolor.dart';

class SensorTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BluetoothService>(
          create: (_) => BluetoothService(),
        ),
        FutureProvider<HiveScanRepository>(
          initialData: null,
          create: (_) async => HiveScanRepository().init(),
          lazy: false,
        ),
        ProxyProvider<HiveScanRepository, ScanService>(
          update: (context, repository, _) => ScanService(repository),
          dispose: (context, service) => service.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Sensor Track',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: TinyColor.fromString("#2c2e3d").color,
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: TinyColor.fromString("#e9af3c").color,
          ),
        ),
        home: Consumer<HiveScanRepository>(
          builder: (context, repository, widget) {
            if (repository == null) {
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
