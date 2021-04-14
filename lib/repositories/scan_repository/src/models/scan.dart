import 'package:sensor_track/repositories/scan_repository/src/entities/scan_entity.dart';
import 'package:uuid/uuid.dart';

class Scan {
  String id;
  final double? temperature;
  final double? humidity;
  final int? pressure;

  /* acceleration x axis in mg */
  final int? accelerationX;
  /* acceleration y axis in mg */
  final int? accelerationY;
  /* acceleration z axis in mg */
  final int? accelerationZ;

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
      createdAt: entity.createdAt,
      sensorDeviceName: entity.sensorDeviceName,
      sensorDeviceLogoURL: entity.sensorDeviceLogoURL,
    );
  }
}
