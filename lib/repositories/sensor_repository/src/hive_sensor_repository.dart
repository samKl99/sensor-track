import 'package:hive/hive.dart';
import 'package:sensor_track/repositories/sensor_repository/src/entities/sensor_entity.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';

import 'models/sensor.dart';

class HiveSensorRepository implements SensorRepository {
  static const SENSOR_HIVE_BOX_KEY = "SENSOR_HIVE_KEY";
  Box<SensorEntity> _sensorBox;

  HiveSensorRepository() {
    Hive.registerAdapter(SensorEntityAdapter());
    Hive.registerAdapter(SensorTypeAdapter());
  }

  Future<HiveSensorRepository> init() async {
    _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    return this;
  }

  @override
  Future<void> addSensor(final Sensor sensor) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    return _sensorBox.put(sensor.deviceId, sensor.toEntity());
  }

  @override
  Future<void> deleteSensor(final Sensor sensor) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    return _sensorBox.delete(sensor.deviceId);
  }

  @override
  Future<void> deleteSensorById(final String id) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    return _sensorBox.delete(id);
  }

  @override
  List<Sensor> sensors({int limit = 100}) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    return _sensorBox.values.take(limit).map((e) => Sensor.fromEntity(e)).toList();
  }

  @override
  Future<void> updateSensor(final Sensor oldSensor, final Sensor newSensor) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    return _sensorBox.put(oldSensor.deviceId, newSensor.toEntity());
  }

  @override
  Sensor sensorById(final String id) {
    if (_sensorBox == null) {
      throw "Sensor Box not initialized";
    }
    final sensor = _sensorBox.values.firstWhere((element) => element.deviceId == id, orElse: () => null);
    return sensor != null ? Sensor.fromEntity(sensor) : null;
  }
}
