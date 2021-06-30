import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sensor_track/components/sensor_track_app_bar.dart';
import 'package:sensor_track/components/sensor_track_button.dart';
import 'package:sensor_track/components/sensor_track_card.dart';
import 'package:sensor_track/components/sensor_track_loading_widget.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/location_service.dart';
import 'package:sensor_track/services/scan_service.dart';
import 'package:sensor_track/services/sensor_service.dart';
import 'package:charcode/charcode.dart';
import 'package:sensor_track/style/style.dart';
import 'package:sensor_track/util/converter_util.dart';

class LiveSensorDeviceScreen extends StatefulWidget {
  final Sensor sensor;

  LiveSensorDeviceScreen({
    required this.sensor,
  });

  @override
  _LiveSensorDeviceScreenState createState() => _LiveSensorDeviceScreenState();
}

class _LiveSensorDeviceScreenState extends State<LiveSensorDeviceScreen> {
  late SensorService _sensorService;
  late ScanService _scanService;
  late LocationService _locationService;

  late bool _isSaving;
  late Color _buttonColor;
  late String _buttonText;
  Icon? _buttonIcon;

  @override
  void initState() {
    _isSaving = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sensorService = Provider.of<SensorService>(context, listen: false);
    _scanService = Provider.of<ScanService>(context, listen: false);
    _locationService = Provider.of<LocationService>(context, listen: false)..listenLocation();

    _sensorService.listenDevice(widget.sensor);

    _setButtonThemeDefault(false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SensorTrackAppBar(
        title: Text(widget.sensor.name != null ? widget.sensor.name! : ""),
      ),
      body: StreamBuilder<bool>(
        stream: _sensorService.singleSensorSearching,
        builder: (context, searchingSnapshot) {
          return StreamBuilder<Position?>(
              stream: _locationService.position,
              builder: (context, locationSnapshot) {
                return StreamBuilder<Sensor?>(
                  stream: _sensorService.singleSensor,
                  builder: (context, snapshot) {
                    if (searchingSnapshot.connectionState == ConnectionState.waiting ||
                        locationSnapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.waiting ||
                        searchingSnapshot.data != null && searchingSnapshot.data!) {
                      return readSensorDataLoadingWidget;
                    } else if (snapshot.hasData && locationSnapshot.hasData) {
                      final sensor = snapshot.data!;
                      final position = locationSnapshot.data!;
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                _getTemperatureCard(sensor.temperature),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                _getHumidityCard(sensor.humidity),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                _getPressureCard(sensor.pressure),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                _getPositionCard(position),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                            child: Container(
                              width: double.infinity,
                              child: SensorTrackButton(
                                text: _buttonText,
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                onPressed: !_isSaving
                                    ? () async {
                                        await _saveScan(sensor, position);
                                      }
                                    : null,
                                loading: _isSaving,
                                color: _buttonColor,
                                icon: _buttonIcon,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: const Text("Es ist ein Fehler aufgetreten"),
                      );
                    } else {
                      return const Center(
                        child: const Text("Keine Daten verfügbar"),
                      );
                    }
                  },
                );
              });
        },
      ),
    );
  }

  _saveScan(final Sensor sensor, final Position position) async {
    setState(() {
      _isSaving = true;
    });

    final Scan scan = Scan(
      temperature: sensor.temperature,
      humidity: sensor.humidity,
      pressure: sensor.pressure,
      latitude: position.latitude,
      longitude: position.longitude,
      sensorDeviceName: sensor.name,
      sensorDeviceLogoURL: sensor.logoURL,
      createdAt: DateTime.now(),
    );

    try {
      await _sensorService.stopListenByDeviceId();
      await _scanService.addScan(widget.sensor, scan);
      _setButtonThemeSavedSuccessfully();
    } catch (e) {
      _setButtonThemeSaveError();
    } finally {
      setState(() {
        _isSaving = false;
      });
    }

    Timer(Duration(milliseconds: 3000), () {
      if (mounted) {
        _sensorService.listenDevice(widget.sensor, showLoadingSpinner: false);
        _setButtonThemeDefault(true);
      }
    });
  }

  void _setButtonThemeSavedSuccessfully() {
    setState(() {
      _buttonColor = Colors.green;
      _buttonIcon = const Icon(
        Icons.check,
        color: Colors.white,
      );
      _buttonText = "Scan gespeichert";
    });
  }

  void _setButtonThemeSaveError() {
    setState(() {
      _buttonColor = Colors.red;
      _buttonIcon = const Icon(
        Icons.close,
        color: Colors.white,
      );
      _buttonText = "Fehler beim Speichern";
    });
  }

  void _setButtonThemeDefault(final bool callSetState) {
    _buttonColor = Theme.of(context).accentColor;
    _buttonIcon = null;
    _buttonText = "Scan speichern";

    if (callSetState && mounted) {
      setState(() {});
    }
  }

  Widget _getTemperatureCard(final double? temperature) {
    return _buildCard(
      FontAwesomeIcons.thermometerThreeQuarters,
      Colors.orange,
      dataString: temperature == null ? "-" : "${temperature.toStringAsFixed(2)} ${String.fromCharCode($deg)}C",
    );
  }

  Widget _getHumidityCard(final double? humidity) {
    return _buildCard(
      FontAwesomeIcons.tint,
      Colors.blueAccent,
      dataString: humidity == null ? "-" : "${humidity.toStringAsFixed(2)} %",
    );
  }

  Widget _getPressureCard(final int? pressure) {
    return _buildCard(
      FontAwesomeIcons.wind,
      Colors.white70,
      dataString: pressure == null ? "-" : "${ConverterUtil.fromPaToHPa(pressure).toStringAsFixed(2)} hPa",
    );
  }

  Widget _getPositionCard(final Position? position) {
    return _buildCard(
      FontAwesomeIcons.mapMarkerAlt,
      Colors.deepOrange,
      dataWidget: position == null
          ? Text("-")
          : Column(
              children: [
                Text(
                  "Lat. ${position.latitude.toStringAsFixed(5)}",
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "Long. ${position.longitude.toStringAsFixed(5)}",
                  style: const TextStyle(fontSize: 24.0),
                )
              ],
            ),
    );
  }

  Widget _buildCard(final IconData icon, final Color iconColor, {final String? dataString, final Widget? dataWidget}) {
    return SensorTrackCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: iconColor,
            size: 35.0,
          ),
          const SizedBox(width: 16.0),
          if (dataString != null)
            Text(
              dataString,
              style: const TextStyle(
                fontSize: 30.0,
              ),
            ),
          if (dataWidget != null) dataWidget,
        ],
      ),
    );
  }

  Widget get readSensorDataLoadingWidget {
    return SensorTrackLoadingWidget(
      icon: Icon(
        Icons.wifi_tethering,
        color: secondaryColor,
        size: 40.0,
      ),
    );
  }

  @override
  void dispose() async {
    _sensorService.stopSearchingSensors();
    super.dispose();
  }
}
