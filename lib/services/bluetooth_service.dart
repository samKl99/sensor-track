import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';

import 'bloc.dart';

class BluetoothService extends Bloc {
  FlutterBlue _flutterBlue;

  Stream<List<SensorDevice>> get sensorDevices => _sensorDevices.stream;

  final _sensorDevices = BehaviorSubject<List<SensorDevice>>.seeded([]);

  BluetoothService() {
    _flutterBlue = FlutterBlue.instance;
  }

  startScan() {

      _sensorDevices.add(mockData());
      /*
      _flutterBlue.startScan(scanMode: ScanMode.lowPower, timeout: Duration(seconds: 3));

      _flutterBlue.scanResults.listen((results) {
        final devices = [...extractRuuviDevices(results)];

        _sensorDevices.add(devices);
      });

       */
  }

  /* filter RuuviTags */
  List<RuuviSensorDevice> extractRuuviDevices(final List<ScanResult> results) {
    final ruuviTags = results.where(
        (element) => element.advertisementData.manufacturerData.containsKey(TagManufacturer.RUUVI_MANUFACTURER_ID));

    //print(ruuviTags.first.advertisementData.manufacturerData[TagManufacturer.RUUVI_MANUFACTURER_ID]);

    return ruuviTags
        .map((e) => RuuviSensorDevice(
              e.rssi,
              e.device.id.id,
              e.device.name,
              e.advertisementData.manufacturerData[TagManufacturer.RUUVI_MANUFACTURER_ID],
            ))
        .toList();
  }

  List<SensorDevice> mockData() {
    final devices = List<RuuviSensorDevice>();

    devices.add(RuuviSensorDevice(12345, "123456789", "TestData", [5, 16, 218, 81, 53, 197, 186, 0, 24, 255, 244, 4, 4, 167, 182, 22, 78, 253, 251, 130, 180, 169, 180, 49]));

    return devices;
  }

  @override
  dispose() async {
    await _sensorDevices.drain();
    await _sensorDevices.close();
  }
}
