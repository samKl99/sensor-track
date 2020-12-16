import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';

import 'bloc.dart';

class BluetoothService extends Bloc {
  FlutterBlue _flutterBlue;

  final _sensorDevices = BehaviorSubject<List<SensorDevice>>.seeded([]);

  BluetoothService() {
    _flutterBlue = FlutterBlue.instance;
  }

  startScan() {
    _flutterBlue.startScan(scanMode: ScanMode.lowPower, timeout: Duration(seconds: 3));

    _flutterBlue.scanResults.listen((results) {
      final devices = [...extractRuuviDevices(results)];

      _sensorDevices.add(devices);
    });
  }

  /* filter RuuviTags */
  List<RuuviSensorDevice> extractRuuviDevices(final List<ScanResult> results) {
    final ruuviTags = results.where(
        (element) => element.advertisementData.manufacturerData.containsKey(TagManufacturer.RUUVI_MANUFACTURER_ID));

    return ruuviTags
        .map((e) => new RuuviSensorDevice(
              e.rssi,
              e.device.id.id,
              e.device.name,
              e.advertisementData.manufacturerData[TagManufacturer.RUUVI_MANUFACTURER_ID],
            ))
        .toList();
  }

  @override
  dispose() async {
    await _sensorDevices.drain();
    await _sensorDevices.close();
  }
}
