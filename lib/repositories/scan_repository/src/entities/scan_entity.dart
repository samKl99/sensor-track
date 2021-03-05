import 'package:hive/hive.dart';

part 'scan_entity.g.dart';

@HiveType(typeId: 1)
class ScanEntity {
  @HiveField(0)
  String id;

  @HiveField(1)
  double temperature;

  @HiveField(2)
  double humidity;

  @HiveField(3)
  int pressure;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String sensorDeviceName;

  @HiveField(6)
  String sensorDeviceLogoURL;

  ScanEntity({
    this.id,
    this.pressure,
    this.temperature,
    this.humidity,
    this.sensorDeviceLogoURL,
    this.sensorDeviceName,
    this.createdAt,
  });
}