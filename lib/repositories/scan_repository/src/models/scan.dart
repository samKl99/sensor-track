import 'package:sensor_track/repositories/scan_repository/src/entities/scan_entity.dart';
import 'package:uuid/uuid.dart';

class Scan {
  String id;
  final double temperature;
  final double humidity;
  final int pressure;
  final DateTime createdAt;
  final String sensorDeviceName;
  final String sensorDeviceLogoURL;

  Scan({
    String id,
    this.temperature,
    this.humidity,
    this.pressure,
    this.createdAt,
    this.sensorDeviceName,
    this.sensorDeviceLogoURL,
  }) : this.id = id ?? Uuid().v4();

  ScanEntity toEntity() {
    return ScanEntity(
      id: id,
      temperature: temperature,
      humidity: humidity,
      pressure: pressure,
      createdAt: createdAt,
      sensorDeviceLogoURL: sensorDeviceLogoURL,
      sensorDeviceName: sensorDeviceName,
    );
  }

  static Scan fromEntity(final ScanEntity entity) {
    return Scan(
      id: entity.id,
      temperature: entity.temperature,
      pressure: entity.pressure,
      humidity: entity.humidity,
      createdAt: entity.createdAt,
      sensorDeviceName: entity.sensorDeviceName,
      sensorDeviceLogoURL: entity.sensorDeviceLogoURL,
    );
  }
}
