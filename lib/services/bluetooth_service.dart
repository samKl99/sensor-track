import 'package:flutter_blue/flutter_blue.dart';

import 'bloc.dart';

class BluetoothService extends Bloc {
  late FlutterBlue _flutterBlue;

  Stream<List<ScanResult>> get scanResults => _flutterBlue.scanResults;

  BluetoothService() {
    _flutterBlue = FlutterBlue.instance;
  }

  Future<void> startScan({final Duration? timeout}) async {
    await _flutterBlue.stopScan();
    await _flutterBlue.startScan(
      scanMode: ScanMode.lowPower,
      timeout: timeout ?? Duration(seconds: 10),
    );
  }

  Future<void> stopScan() async {
    await _flutterBlue.stopScan();
  }

  Stream<ScanResult> listenByDeviceMacAddress(final String macAddress) {
    return _flutterBlue.scan(withDevices: [Guid.fromMac(macAddress)]);
  }

  Stream<ScanResult> listenByDeviceId(final String id) {
    return _flutterBlue.scan().where((result) => result.device.id.id == id);
  }

  @override
  dispose() async {
  }
}
