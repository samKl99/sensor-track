import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/tag_manufacturer.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/texas_instruments_sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/texas_instruments/texas_instruments_service.dart';
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

  Stream<bool> get singleSensorSearching => _singleSensorSearching.stream;

  final _sensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _registeredSensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _singleSensor = BehaviorSubject<Sensor?>.seeded(null);
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _searching = BehaviorSubject<bool>.seeded(false);
  final _singleSensorSearching = BehaviorSubject<bool>.seeded(false);

  final Set<blue.BluetoothDevice> _connectedDevices = Set();

  SensorRepository _sensorRepository;
  sensorTrack.BluetoothService _bluetoothService;
  IotaService _iotaService;
  TexasInstrumentsService _texasInstrumentsService;

  SensorService(this._sensorRepository, this._bluetoothService, this._iotaService, this._texasInstrumentsService);

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
    _connectedDevices.forEach((element) {
      element.disconnect();
    });
    _searching.add(false);
    _singleSensor.add(null);
  }

  Future<void> getRegisteredSensors({int limit = 15}) async {
    _loading.add(true);
    try {
      final iotaSensorDevices = await _iotaService.getUserDevices();
      final iotaSensorsSks = iotaSensorDevices.map((e) => e.sk);
      final persistedSensors = await _sensorRepository.sensors(limit: limit);
      final filteredSensors = persistedSensors.where((element) => iotaSensorsSks.contains(element.iotaSk)).toList();
      filteredSensors.forEach((sensor) {
        final iotaSensorData = iotaSensorDevices.firstWhereOrNull((iotaDevice) => iotaDevice.sk == sensor.iotaSk);
        sensor.iotaSk = iotaSensorData?.sk;
        sensor.iotaDeviceId = iotaSensorData!.sensorId;
        sensor.iotaDeviceData = iotaSensorData;
      });
      _registeredSensors.add(filteredSensors);
    } catch (e) {
      print(e);
      _registeredSensors.addError("error loading sensors");
    } finally {
      _loading.add(false);
    }
  }

  void listenDevice(final Sensor sensor, {final bool showLoadingSpinner = true}) {
    if (sensor.type == SensorType.RUUVI && sensor.macAddress != null) {
      _listenRuuviDevice(sensor.macAddress!, showLoadingSpinner: showLoadingSpinner);
    }

    if (sensor.type == SensorType.TEXAS_INSTRUMENTS) {
      _listenTexasInstrumentsDevice(sensor.id!);
    }
  }

  void _listenRuuviDevice(final String macAddress, {final bool showLoadingSpinner = true}) {
    if (showLoadingSpinner) {
      _singleSensorSearching.add(true);
      _singleSensor.add(null);
    }

    _bluetoothService.listenByDeviceMacAddress(macAddress).listen((result) => _listenOnRuuviDevice(result));
  }

  void _listenTexasInstrumentsDevice(final String id) async {
    _singleSensorSearching.add(true);
    _bluetoothService.listenByDeviceId(id).listen((result) async {
      final device = result.device;

      await device.connect();
      _connectedDevices.add(device);

      final temperatureStream = await _texasInstrumentsService.enableTemperature(device);
      final humidityStream = await _texasInstrumentsService.enableHumidity(device);
      final pressureStream = await _texasInstrumentsService.enablePressure(device);

      if (temperatureStream != null && humidityStream != null && pressureStream != null) {
        final combinedStream = Rx.zip3<double?, double?, int?, Set<TexasInstrumentsSensorDevice>>(
            temperatureStream,
            humidityStream,
            pressureStream,
            (temp, hum, press) => {
                  TexasInstrumentsSensorDevice(
                    id: device.id.id,
                    name: device.name,
                    temperature: temp,
                    humidity: hum,
                    pressure: press,
                  )
                });

        combinedStream.listen((devices) {
          final device = devices.first;
          if (device.temperature != null && device.humidity != null && device.pressure != null) {
            _singleSensor.add(device);
            _singleSensorSearching.add(false);
          }
        });
      }
    });
  }

  Future<void> stopListenByDeviceId() async {
    await _bluetoothService.stopScan();
  }

  Future<void> addSensor(final Sensor sensor) async {
    if (await isSensorPersisted(sensor.id)) {
      throw "sensor already persisted";
    }

    await _sensorRepository.addSensor(sensor);
  }

  Future<void> deleteSensor(final Sensor sensor) async {
    _loading.add(true);

    try {
      await _sensorRepository.deleteSensorById(sensor.id!);
      if (sensor.iotaDeviceId != null) {
        await _iotaService.deleteDevice(sensor.iotaDeviceId!);
      }
    } catch (e) {
      rethrow;
    } finally {
      _loading.add(false);
    }
  }

  Future<bool> isSensorPersisted(final String? id) async {
    if (id == null) {
      return false;
    }
    return await _sensorRepository.sensorById(id) != null;
  }

  Future<void> _listenOnSensorDevices(final List<blue.ScanResult> results) async {
    final devices = _getDevices(results);

    if (devices.isNotEmpty) {
      final registeredDevices = await Future.wait(devices.map((e) async {
        await isSensorPersisted(e.id) ? e.registeredOnDataMarketplace = true : e.registeredOnDataMarketplace = false;
        return e;
      }).toList());

      _sensors.add(registeredDevices.where((element) => element.registeredOnDataMarketplace == false).toList());
    }
  }

  void _listenOnRuuviDevice(final blue.ScanResult result) {
    final ruuviDevices = _getDevices([result]).where((element) => element.type == SensorType.RUUVI);
    if (ruuviDevices.isNotEmpty) {
      _singleSensor.add(ruuviDevices.first);
      _singleSensorSearching.add(false);
    }
  }

  List<Sensor> _getDevices(final List<blue.ScanResult> results) {
    return [
      ..._extractRuuviDevices(results),
      ..._extractTISensorTagDevices(results),
    ];
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

  List<Sensor> _extractTISensorTagDevices(final List<blue.ScanResult> results) {
    final tiSensors = results.where((element) => element.device.name == "SensorTag" || element.device.name == "TI BLE Sensor Tag");

    return tiSensors
        .map((e) => TexasInstrumentsSensorDevice(
              id: e.device.id.id,
              name: e.device.name,
            ))
        .toList();
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

    _singleSensorSearching.drain();
    _singleSensorSearching.close();
  }
}
