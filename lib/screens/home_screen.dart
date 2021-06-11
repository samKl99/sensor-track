import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/fade_route_builder.dart';
import 'package:sensor_track/components/sensor_track_app_bar.dart';
import 'package:sensor_track/screens/last_scans_screen.dart';
import 'package:sensor_track/screens/sensor_scan_screen.dart';
import 'package:sensor_track/screens/sensor_screen.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/style/style.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _fabButtonKey = GlobalKey();
  Rect? _fabButtonRect;
  Rect? _pageTransitionRect;
  late int _currentIndex;

  AuthenticationService get _authenticationService => Provider.of<AuthenticationService>(context, listen: false);

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
    return Stack(
      children: [
        Scaffold(
          appBar: SensorTrackAppBar(
            title: Text(_titles[_currentIndex]),
            actions: [
              IconButton(
                icon: Icon(Icons.logout_outlined),
                onPressed: () async {
                  await _authenticationService.logout();
                },
              ),
            ],
          ),
          body: _targetsScreens[_currentIndex],
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  key: _fabButtonKey,
                  child: Icon(Icons.add),
                  //onPressed: () => _startPageTransition(),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanScreen()));
                  },
                )
              : null,
        ),
        _pageTransition
      ],
    );
  }

  void _startPageTransition() {
    setState(() {
      _fabButtonRect = _getWidgetRect(_fabButtonKey);
      _pageTransitionRect = _fabButtonRect;
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final fullscreenSize = 1.3 * MediaQuery.of(context).size.longestSide;
      setState(() => _pageTransitionRect = _pageTransitionRect?.inflate(fullscreenSize));
    });
  }

  Rect? _getWidgetRect(GlobalKey globalKey) {
    var renderObject = globalKey.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    var size = renderObject?.semanticBounds.size;

    if (translation != null && size != null) {
      return new Rect.fromLTWH(translation.x, translation.y, size.width, size.height);
    } else {
      return null;
    }
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

  Widget get _pageTransition {
    if (_pageTransitionRect == null) {
      return Container();
    }

    return AnimatedPositioned.fromRect(
      rect: _pageTransitionRect!,
      duration: Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColorLight,
        ),
      ),
      onEnd: () {
        bool shouldNavigatePage = _pageTransitionRect != _fabButtonRect;
        if (shouldNavigatePage) {
          Navigator.push(
            context,
            FadeRouteBuilder(page: ScanScreen()),
          ).then((_) {
            setState(() => _pageTransitionRect = _fabButtonRect);
          });
        } else {
          setState(() => _pageTransitionRect = null);
        }
      },
    );
  }

  void _navigate(final int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
