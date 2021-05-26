import 'package:hive/hive.dart';
import 'package:sensor_track/repositories/sensor_repository/src/entities/sensor_entity.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:sensor_track/repositories/sensor_repository/src/sensor_repository.dart';
import 'package:collection/collection.dart';

import 'models/sensor.dart';

class HiveSensorRepository implements SensorRepository {
  static const SENSOR_HIVE_BOX_KEY = "SENSOR_HIVE_KEY";

  HiveSensorRepository() {
    Hive.registerAdapter(SensorEntityAdapter());
    Hive.registerAdapter(SensorTypeAdapter());
  }

  @override
  Future<void> addSensor(final Sensor sensor) async {
    final _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    return _sensorBox.put(sensor.id, sensor.toEntity());
  }

  @override
  Future<void> deleteSensor(final Sensor sensor) async {
    if (sensor.id != null) {
      return await deleteSensorById(sensor.id!);
    }
  }

  @override
  Future<void> deleteSensorById(final String id) async {
    final _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    return _sensorBox.delete(id);
  }

  @override
  Future<List<Sensor>> sensors({int limit = 100}) async {
    final _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    return _sensorBox.values.take(limit).map((e) => Sensor.fromEntity(e)).toList();
  }

  @override
  Future<void> updateSensor(final Sensor oldSensor, final Sensor newSensor) async {
    final _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    return _sensorBox.put(oldSensor.id, newSensor.toEntity());
  }

  @override
  Future<Sensor?> sensorById(final String? id) async {
    final _sensorBox = await Hive.openBox(SENSOR_HIVE_BOX_KEY);
    final sensor = _sensorBox.values.firstWhereOrNull((element) => element.id == id);
    return sensor != null ? Sensor.fromEntity(sensor) : null;
  }
}
