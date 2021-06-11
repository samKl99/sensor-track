import 'package:sensor_track/repositories/sensor_repository/src/models/sensor.dart';

abstract class SensorRepository {
  Future<void> addSensor(Sensor sensor);

  Future<void> deleteSensor(Sensor sensor);

  Future<void> deleteSensorById(String id);

  Future<List<Sensor>> sensors({int limit});

  Future<void> updateSensor(Sensor oldSensor, Sensor newSensor);

  Future<Sensor?> sensorById(String id);

  Future<Sensor?> sensorByMacAddress(String macAddress);
}
