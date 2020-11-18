import 'package:flutter_blue/flutter_blue.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';

class BluetoothService {
  FlutterBlue _flutterBlue;

  BluetoothService() {
    _flutterBlue = FlutterBlue.instance;
  }

  startScan2() {
    _flutterBlue.startScan(scanMode: ScanMode.lowPower, timeout: Duration(seconds: 3));

    _flutterBlue.scanResults.listen((results) {
      /* filter RuuviTags */
      final ruuviTags = results.where(
          (element) => element.advertisementData.manufacturerData.containsKey(TagManufacturer.RUUVI_MANUFACTURER_ID));
    });
  }
}
