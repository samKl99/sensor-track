import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/repositories/authentication_repository/authentication_repository.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/screens/auth_screen.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';

class SensorTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BluetoothService>(
          create: (_) => BluetoothService(),
          dispose: (context, service) => service.dispose(),
        ),
        Provider<HiveScanRepository>(
          create: (_) => HiveScanRepository(),
        ),
        Provider<FirebaseAuthenticationRepository>(
          create: (_) => FirebaseAuthenticationRepository(firebaseAuth: FirebaseAuth.instance),
        ),
        Provider<HiveSensorRepository>(
          create: (_) => HiveSensorRepository(),
        ),
        ProxyProvider<HiveScanRepository, ScanService>(
          update: (context, repository, _) => ScanService(repository),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider<FirebaseAuthenticationRepository, AuthenticationService>(
          update: (context, repository, _) => AuthenticationService(repository)..isUserAuthenticated(),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider2<HiveSensorRepository, BluetoothService, SensorService>(
          update: (context, repository, bluetoothService, _) => SensorService(repository, bluetoothService),
          dispose: (context, service) => service.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Sensor Track',
        debugShowCheckedModeBanner: false,
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
        home: AuthScreen(),
      ),
    );
  }
}
