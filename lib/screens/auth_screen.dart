import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/screens/home_screen.dart';
import 'package:sensor_track/screens/login_screen.dart';
import 'package:sensor_track/screens/splash_screen.dart';
import 'package:sensor_track/services/authentication_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationService = Provider.of<AuthenticationService>(context);

    return StreamBuilder<bool>(
      stream: authenticationService.isAuthenticating,
      builder: (context, loadingSnapshot) {
        return StreamBuilder(
          stream: authenticationService.user,
          builder: (context, snapshot) {
            if (loadingSnapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.waiting ||
                loadingSnapshot.data != null && loadingSnapshot.data!) {
              return SplashScreen();
            } else if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        );
      },
    );
  }
}
