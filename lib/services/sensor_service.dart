import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';
import 'package:sensor_track/services/bloc.dart';
import 'package:sensor_track/services/bluetooth_service.dart' as sensorTrack;

class SensorService extends Bloc {
  Stream<List<Sensor>> get sensors => _sensors.stream;

  Stream<bool> get loading => _loading.stream;

  Stream<bool> get searching => _searching.stream;

  final _sensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _searching = BehaviorSubject<bool>.seeded(false);

  SensorRepository _sensorRepository;
  sensorTrack.BluetoothService _bluetoothService;

  SensorService(this._sensorRepository, this._bluetoothService);

  searchSensors() {
    _searching.add(true);
    _sensors.add([]);
    _bluetoothService.startScan();
    _bluetoothService.scanResults.listen((results) => _listenOnSensorDevices(results));
  }

  stopSearchingSensors() {
    _bluetoothService.stopScan();
  }

  Future<void> getSavedSensors({int limit = 15}) async {
    _loading.add(true);
    try {
      _sensors.add(await _sensorRepository.sensors(limit: limit));
    } catch (e) {
      _sensors.addError("error loading sensors");
    } finally {
      _loading.add(false);
    }
  }

  void listenByDeviceId(final String macAddress) {
    _searching.add(true);
    _sensors.add([]);
    _bluetoothService.listenByDeviceId(macAddress).listen((result) => _listenOnSingleSensorDevice(result));
  }

  Future<void> addSensor(final Sensor sensor) async {
    if (await isSensorPersisted(sensor.id)) {
      throw "sensor already persisted";
    }

    await _sensorRepository.addSensor(sensor);
  }

  Future<void> deleteSensorById(final String id) async {
    await _sensorRepository.deleteSensorById(id);
  }

  Future<bool> isSensorPersisted(final String? id) async {
    return await _sensorRepository.sensorById(id) != null;
  }

  Future<void> _listenOnSensorDevices(final List<blue.ScanResult> results) async {
    final devices = _getDevices(results);

    if (devices.isNotEmpty) {
      devices.map((e) async => await isSensorPersisted(e.id) ? e.persisted = true : e.persisted = false).toList();
      _sensors.add(devices);
      _searching.add(false);
    }
  }

  void _listenOnSingleSensorDevice(final blue.ScanResult result) {
    _listenOnSensorDevices([result]);
  }

  List<Sensor> _getDevices(final List<blue.ScanResult> results) {
    return [..._extractRuuviDevices(results)];
  }

  /* filter RuuviTags */
  List<RuuviSensorDevice> _extractRuuviDevices(final List<blue.ScanResult> results) {
    final ruuviTags =
        results.where((element) => element.advertisementData.manufacturerData.containsKey(TagManufacturer.RUUVI_MANUFACTURER_ID));

    return ruuviTags
        .map((e) => RuuviSensorDevice(
              id: e.device.id.id,
              name: e.device.name.isNotEmpty ? e.device.name : null,
              data: e.advertisementData.manufacturerData[TagManufacturer.RUUVI_MANUFACTURER_ID],
            ))
        .toList();
  }

  List<Sensor> _mockData() {
    return [
      RuuviSensorDevice(
          id: "123456789",
          name: "Sensor 1",
          data: [5, 16, 218, 81, 53, 197, 186, 0, 24, 255, 244, 4, 4, 167, 182, 22, 78, 253, 251, 130, 180, 169, 180, 49]),
      RuuviSensorDevice(
          id: "123456789",
          name: "Sensor 2",
          data: [5, 16, 218, 81, 53, 197, 186, 0, 24, 255, 244, 4, 4, 167, 182, 22, 78, 253, 251, 130, 180, 169, 180, 49])
    ];
  }

  @override
  dispose() {
    _sensors.drain();
    _sensors.close();

    _loading.drain();
    _loading.close();

    _searching.drain();
    _searching.close();
  }
}
