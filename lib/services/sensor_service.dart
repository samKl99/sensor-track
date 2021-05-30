import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';
import 'package:sensor_track/services/bloc.dart';
import 'package:sensor_track/services/bluetooth_service.dart' as sensorTrack;
import 'package:sensor_track/services/iota_service.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class SensorService extends Bloc {
  static const SEARCH_DURATION = Duration(seconds: 10);

  Stream<List<Sensor>> get sensors => _sensors.stream;

  Stream<List<Sensor>> get registeredSensors => _registeredSensors.stream;

  Stream<Sensor?> get singleSensor => _singleSensor.stream;

  Stream<bool> get loading => _loading.stream;

  Stream<bool> get searching => _searching.stream;

  final _sensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _registeredSensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _singleSensor = BehaviorSubject<Sensor?>.seeded(null);
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _searching = BehaviorSubject<bool>.seeded(false);

  SensorRepository _sensorRepository;
  sensorTrack.BluetoothService _bluetoothService;
  IotaService _iotaService;

  SensorService(this._sensorRepository, this._bluetoothService, this._iotaService);

  searchSensors() {
    _searching.add(true);
    _sensors.add([]);
    _bluetoothService.startScan(timeout: SEARCH_DURATION);
    _bluetoothService.scanResults.listen((results) => _listenOnSensorDevices(results));

    int durationSeconds = SEARCH_DURATION.inSeconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (durationSeconds == 0) {
        stopSearchingSensors();
        timer.cancel();
      } else {
        durationSeconds--;
      }
    });
  }

  stopSearchingSensors() {
    _bluetoothService.stopScan();
  }

  Future<void> getRegisteredSensors({int limit = 15}) async {
    _loading.add(true);
    try {
      final iotaSensorDevices = await _iotaService.getUserDevices();
      final iotaSensorsSks = iotaSensorDevices.map((e) => e.sk);
      final persistedSensors = await _sensorRepository.sensors(limit: limit);
      final filteredSensors = persistedSensors.where((element) => iotaSensorsSks.contains(element.iotaSk)).toList();
      filteredSensors.forEach((sensor) {
        sensor.iotaDeviceData = iotaSensorDevices.firstWhereOrNull((iotaDevice) => iotaDevice.sk == sensor.iotaSk);
      });
      _registeredSensors.add(filteredSensors);
    } catch (e) {
      print(e);
      _registeredSensors.addError("error loading sensors");
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

  Future<void> deleteSensor(final Sensor sensor) async {
    await _sensorRepository.deleteSensorById(sensor.id!);
    if (sensor.iotaDeviceId != null) {
      await _iotaService.deleteDevice(sensor.iotaDeviceId!);
    }
  }

  Future<bool> isSensorPersisted(final String? id) async {
    if (id == null) {
      return false;
    }
    return await _sensorRepository.sensorById(id) != null;
  }

  Future<bool> isSensorPersistedByMacAddress(final String? macAddress) async {
    if (macAddress == null) {
      return false;
    }
    return await _sensorRepository.sensorByMacAddress(macAddress) != null;
  }

  Future<void> _listenOnSensorDevices(final List<blue.ScanResult> results) async {
    final devices = _getDevices(results);

    if (devices.isNotEmpty) {
      final registeredDevices = await Future.wait(devices.map((e) async {
        await isSensorPersistedByMacAddress(e.macAddress) ? e.registeredOnDataMarketplace = true : e.registeredOnDataMarketplace = false;
        return e;
      }).toList());

      _sensors.add(registeredDevices.where((element) => element.registeredOnDataMarketplace == false).toList());
      _searching.add(false);
    }
  }

  void _listenOnSingleSensorDevice(final blue.ScanResult result) {
    final devices = _getDevices([result]);
    if (devices.isNotEmpty) {
      _singleSensor.add(devices.first);
      _searching.add(false);
    }
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

    _registeredSensors.drain();
    _registeredSensors.close();

    _singleSensor.drain();
    _singleSensor.close();

    _loading.drain();
    _loading.close();

    _searching.drain();
    _searching.close();
  }
}
