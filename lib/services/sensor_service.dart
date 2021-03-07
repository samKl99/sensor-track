import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/models/ruuvi_sensor_device.dart';
import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';
import 'package:sensor_track/services/bloc.dart';

class SensorService extends Bloc {
  static const _RUUVI_SENSOR_IMAGE_URL = "assets/sensor-icons/ruuvi.png";
  static const _TEXAS_INSTRUMENTS_SENSOR_IMAGE_URL = "assets/sensor-icons/texas_instruments.png";

  Stream<List<Sensor>> get sensors => _sensors.stream;

  Stream<bool> get loading => _loading.stream;

  final _sensors = BehaviorSubject<List<Sensor>>.seeded([]);
  final _loading = BehaviorSubject<bool>.seeded(false);

  SensorRepository _sensorRepository;

  SensorService(this._sensorRepository);

  static String getLogoImageForSensor(final SensorDevice sensorDevice) {
    String logoURL;
    if (sensorDevice is RuuviSensorDevice) {
      logoURL = _RUUVI_SENSOR_IMAGE_URL;
    }

    return logoURL;
  }

  getSavedSensors({int limit = 15}) {
    _loading.add(true);
    try {
      _sensors.add(_sensorRepository.sensors(limit: limit));
    } catch (e) {
      _sensors.addError("error loading sensors");
    } finally {
      _loading.add(false);
    }
  }

  addSensor(final SensorDevice sensorDevice) {
    if (isSensorPersisted(sensorDevice.id)) {
      throw "sensor already persisted";
    }

    final sensor = Sensor(
      name: sensorDevice.name,
      logoURL: sensorDevice.logoURL,
      deviceId: sensorDevice.id,
    );

    if (sensorDevice is RuuviSensorDevice) {
      sensor.type = SensorType.RUUVI;
    } else {
      sensor.type = SensorType.UNKOWN;
    }

    _sensorRepository.addSensor(sensor);
  }

  deleteSensorById(final String id){
    _sensorRepository.deleteSensorById(id);
  }

  bool isSensorPersisted(final String deviceId) {
    return _sensorRepository.sensorById(deviceId) != null;
  }

  @override
  dispose() {
    _sensors.drain();
    _sensors.close();

    _loading.drain();
    _loading.close();
  }
}
