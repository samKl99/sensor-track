import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensor_track/screens/last_scans_screen.dart';
import 'package:sensor_track/screens/scan_screen.dart';
import 'package:sensor_track/screens/sensor_screen.dart';
import 'package:sensor_track/style/style.dart';
import 'package:tinycolor/tinycolor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _fabDimension = 80.0;
  int _currentIndex;

  final _tabs = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Sensoren",
      activeIcon: SvgPicture.asset(
        "assets/icons/sensors.svg",
        semanticsLabel: "Übersicht",
        color: secondaryColor,
      ),
      icon: SvgPicture.asset(
        "assets/icons/sensors.svg",
        semanticsLabel: "Übersicht",
        color: Colors.white,
      ),
    ),
    BottomNavigationBarItem(label: "Scans", icon: Icon(Icons.list_rounded)),
  ];

  final _targetsScreens = [
    SensorScreen(),
    LastScansScreen(),
  ];

  final _titles = ["Sensoren", "Letzte Scans"];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TinyColor.fromString("#2c2e3d").color,
      ),
      body: _targetsScreens[_currentIndex],
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentIndex == 0
          ? OpenContainer(
              transitionType: ContainerTransitionType.fade,
              openBuilder: (context, _) {
                return ScanScreen();
              },
              closedElevation: 6,
              openShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_fabDimension / 2),
                ),
              ),
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(_fabDimension / 2),
                ),
              ),
              openColor: TinyColor.fromString("#2c2e3d").color,
              closedColor: TinyColor.fromString("#2c2e3d").color,
              closedBuilder: (BuildContext context, VoidCallback openContainer) {
                return FloatingActionButton(
                  child: Icon(Icons.add),
                );
              },
            )
          : null,
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        elevation: 16.0,
        backgroundColor: primaryColorDark,
        currentIndex: _currentIndex,
        onTap: _navigate,
        type: BottomNavigationBarType.fixed,
        items: _tabs,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.white,
        unselectedFontSize: 14,
      ),
    );
  }

  void _navigate(final int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
