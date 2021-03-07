import 'package:hive/hive.dart';

part 'sensor_type.g.dart';

@HiveType(typeId: 3)
enum SensorType {
  @HiveField(0)
  UNKOWN,
  @HiveField(1)
  RUUVI
}
