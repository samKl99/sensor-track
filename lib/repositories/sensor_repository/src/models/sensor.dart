import 'package:sensor_track/repositories/sensor_repository/src/entities/sensor_entity.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:uuid/uuid.dart';

class Sensor {
  String id;
  SensorType type;
  String name;
  String logoURL;
  String deviceId;

  Sensor({
    String id,
    this.type,
    this.name,
    this.logoURL,
    this.deviceId,
  }) : this.id = id ?? Uuid().v4();

  SensorEntity toEntity() {
    return SensorEntity(
      id: this.id,
      type: this.type,
      name: this.name,
      logoURL: this.logoURL,
      deviceId: this.deviceId,
    );
  }

  static Sensor fromEntity(final SensorEntity entity) {
    return Sensor(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      logoURL: entity.logoURL,
      deviceId: entity.deviceId,
    );
  }
}
