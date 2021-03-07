import 'package:hive/hive.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';

part 'sensor_entity.g.dart';

@HiveType(typeId: 2)
class SensorEntity {
  @HiveField(0)
  String id;

  @HiveField(1)
  SensorType type;

  @HiveField(2)
  String name;

  @HiveField(3)
  String logoURL;

  @HiveField(4)
  String deviceId;

  SensorEntity({
    this.id,
    this.type,
    this.name,
    this.logoURL,
    this.deviceId,
  });
}
