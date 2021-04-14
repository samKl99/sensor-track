import 'package:hive/hive.dart';

part 'scan_entity.g.dart';

@HiveType(typeId: 1)
class ScanEntity {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double? temperature;

  @HiveField(2)
  double? humidity;

  @HiveField(3)
  int? pressure;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  String? sensorDeviceName;

  @HiveField(6)
  String? sensorDeviceLogoURL;

  @HiveField(7)
  int? accelerationX;

  @HiveField(8)
  int? accelerationY;

  @HiveField(9)
  int? accelerationZ;

  ScanEntity({
    this.id,
    this.pressure,
    this.temperature,
    this.humidity,
    this.accelerationX,
    this.accelerationY,
    this.accelerationZ,
    this.sensorDeviceLogoURL,
    this.sensorDeviceName,
    this.createdAt,
  });
}