import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/entities/sensor_entity.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:uuid/uuid.dart';

class Sensor {
  static const _RUUVI_SENSOR_IMAGE_URL = "assets/sensor-icons/ruuvi.png";
  static const _TEXAS_INSTRUMENTS_SENSOR_IMAGE_URL = "assets/sensor-icons/texas_instruments.png";

  String? id;
  String? iotaSk;
  String? iotaDeviceId;
  SensorType? type;
  String? name;
  String? logoURL;
  String? macAddress;
  bool? registeredOnDataMarketplace;
  IotaDevice? iotaDeviceData;

  double? temperature;
  double? humidity;
  int? pressure;

  Sensor({
    String? id,
    bool? registeredOnDataMarketplace,
    this.iotaSk,
    this.iotaDeviceId,
    this.macAddress,
    this.type,
    this.name,
    this.temperature,
    this.humidity,
    this.pressure,
    this.iotaDeviceData,
  }) {
    this.id = id ?? Uuid().v4();
    this.registeredOnDataMarketplace = registeredOnDataMarketplace ?? false;

    if (this.type == SensorType.RUUVI) {
      this.logoURL = _RUUVI_SENSOR_IMAGE_URL;
    }

    if (this.type == SensorType.TEXAS_INSTRUMENTS) {
      this.logoURL = _TEXAS_INSTRUMENTS_SENSOR_IMAGE_URL;
    }
  }

  SensorEntity toEntity() {
    return SensorEntity(
      id: this.id,
      type: this.type,
      name: this.name,
      logoURL: this.logoURL,
      macAddress: this.macAddress,
      iotaSk: this.iotaSk,
      iotaDeviceId: this.iotaDeviceId,
    );
  }

  static Sensor fromEntity(final SensorEntity entity) {
    return Sensor(
      id: entity.id,
      type: entity.type,
      name: entity.name,
      macAddress: entity.macAddress,
      registeredOnDataMarketplace: true,
      iotaSk: entity.iotaSk,
      iotaDeviceId: entity.iotaDeviceId,
    );
  }
}
