import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/repositories/authentication_repository/authentication_repository.dart';
import 'package:sensor_track/repositories/iota_repository/src/iota_client.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/screens/auth_screen.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/screens/sensor_screen.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/bluetooth_service.dart';
import 'package:sensor_track/services/iota_service.dart';
import 'package:sensor_track/services/location_service.dart';
import 'package:sensor_track/services/notification_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:sensor_track/style/style.dart';

import 'repositories/iota_repository/iota_repository.dart';

class SensorTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BluetoothService>(
          create: (_) => BluetoothService(),
          dispose: (context, service) => service.dispose(),
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(),
        ),
        Provider<IotaClient>(
          create: (_) => IotaClient(IotaConfiguration()),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
          lazy: false,
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
        ProxyProvider2<IotaClient, FirebaseAuthenticationRepository, AuthenticationService>(
          update: (context, client, repository, _) => AuthenticationService(repository, client)..isUserAuthenticated(),
          //dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider2<IotaClient, AuthenticationService, IotaService>(
          update: (context, client, authenticationService, _) => IotaService(client, authenticationService),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider2<IotaService, HiveScanRepository, ScanService>(
          update: (context, iotaService, repository, _) => ScanService(repository, iotaService),
          dispose: (context, service) => service.dispose(),
        ),
        ProxyProvider3<IotaService, HiveSensorRepository, BluetoothService, SensorService>(
          update: (context, iotaService, repository, bluetoothService, _) => SensorService(repository, bluetoothService, iotaService),
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
