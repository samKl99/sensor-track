import 'package:sensor_track/repositories/scan_repository/src/entities/scan_entity.dart';
import 'package:uuid/uuid.dart';

class Scan {
  String id;

  // temperature in C
  final double? temperature;

  // humidity in %
  final double? humidity;

  // pressure in pa
  final int? pressure;

  /* acceleration x axis in mg */
  final int? accelerationX;

  /* acceleration y axis in mg */
  final int? accelerationY;

  /* acceleration z axis in mg */
  final int? accelerationZ;

  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final String? sensorDeviceName;
  final String? sensorDeviceLogoURL;

  Scan({
    String? id,
    this.temperature,
    this.humidity,
    this.pressure,
    this.accelerationX,
    this.accelerationY,
    this.accelerationZ,
    this.longitude,
    this.latitude,
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
      accelerationX: accelerationY,
      accelerationY: accelerationY,
      accelerationZ: accelerationZ,
      latitude: latitude,
      longitude: longitude,
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
      accelerationX: entity.accelerationX,
      accelerationY: entity.accelerationY,
      accelerationZ: entity.accelerationZ,
      latitude: entity.latitude,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
      sensorDeviceName: entity.sensorDeviceName,
      sensorDeviceLogoURL: entity.sensorDeviceLogoURL,
    );
  }
}
