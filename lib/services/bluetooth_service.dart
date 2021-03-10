import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';
import 'package:sensor_track/services/sensor_service.dart';

import 'bloc.dart';

class BluetoothService extends Bloc {
  FlutterBlue _flutterBlue;
  SensorService _sensorService;

  Stream<List<SensorDevice>> get sensorDevices => _sensorDevices.stream;

  Stream<bool> get searching => _searching.stream;

  final _sensorDevices = BehaviorSubject<List<SensorDevice>>.seeded([]);
  final _searching = BehaviorSubject<bool>.seeded(false);

  BluetoothService(this._sensorService) {
    _flutterBlue = FlutterBlue.instance;
    _listenOnBluetoothDevices();
  }

  Future<void> startScan() async {
    _searching.add(true);

    if (!kDebugMode) {
      _sensorDevices.add(mockData());
    } else {
      await _flutterBlue.startScan(
        scanMode: ScanMode.lowPower,
        timeout: Duration(seconds: 10),
      );

      _searching.add(false);
    }
  }

  Future<void> stopScan() async {
    await _flutterBlue.stopScan();
  }

  void _listenOnBluetoothDevices() {
    _flutterBlue.scanResults.listen((final List<ScanResult> results) {
      final devices = [..._extractRuuviDevices(results)];

      if (devices.isNotEmpty) {
        devices.map((e) => _isPersisted(e) ? e.persisted = true : e.persisted = false).toList();
        _sensorDevices.add(devices);
        _searching.add(false);
      }
    });
  }

/* filter RuuviTags */
  List<RuuviSensorDevice> _extractRuuviDevices(final List<ScanResult> results) {
    final ruuviTags =
        results.where((element) => element.advertisementData.manufacturerData.containsKey(TagManufacturer.RUUVI_MANUFACTURER_ID));

    return ruuviTags
        .map((e) => RuuviSensorDevice(
              e.device.id.id,
              e.device.name.isNotEmpty ? e.device.name : null,
              e.advertisementData.manufacturerData[TagManufacturer.RUUVI_MANUFACTURER_ID],
            ))
        .toList();
  }

  bool _isPersisted(final SensorDevice sensorDevice) {
    return _sensorService.isSensorPersisted(sensorDevice.id);
  }

  List<SensorDevice> mockData() {
    return [
      RuuviSensorDevice("123456789", "Sensor 1",
          [5, 16, 218, 81, 53, 197, 186, 0, 24, 255, 244, 4, 4, 167, 182, 22, 78, 253, 251, 130, 180, 169, 180, 49]),
      RuuviSensorDevice("123456789", "Sensor 2",
          [5, 16, 218, 81, 53, 197, 186, 0, 24, 255, 244, 4, 4, 167, 182, 22, 78, 253, 251, 130, 180, 169, 180, 49])
    ];
  }

  @override
  dispose() async {
    _sensorDevices.drain();
    _sensorDevices.close();

    _searching.drain();
    _searching.close();
  }
}
