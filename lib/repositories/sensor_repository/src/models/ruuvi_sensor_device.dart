import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';
import 'package:sensor_track/ruuvi/data_format_5_decoder.dart';
import 'package:sensor_track/ruuvi/ruuvi_acceleration.dart';
import 'package:sensor_track/ruuvi/ruuvi_power_info.dart';

class RuuviSensorDevice extends Sensor {
  RuuviAcceleration? acceleration;
  RuuviPowerInfo? powerInfo;

  RuuviSensorDevice({
    required String id,
    String? name,
    List<int>? data,
  }) : super(id: id, type: SensorType.RUUVI, macAddress: data != null ? RuuviDataFormat5Decoder.getMACAddress(data) : null) {
    temperature = data != null ? RuuviDataFormat5Decoder.getTemperature(data) : null;
    humidity = data != null ? RuuviDataFormat5Decoder.getHumidity(data) : null;
    pressure = data != null ? RuuviDataFormat5Decoder.getPressure(data) : null;
    acceleration = data != null ? RuuviDataFormat5Decoder.getAcceleration(data) : null;
    powerInfo = data != null ? RuuviDataFormat5Decoder.getPowerInfo(data) : null;
    this.name = _getSensorDeviceName(macAddress);
  }

  String _getSensorDeviceName(final String? macAddress) {
    return macAddress != null && macAddress.isNotEmpty ? "Ruuvi ${macAddress.substring(macAddress.length - 6).replaceAll(":", "")}" : "";
  }

  @override
  String toString() {
    return "RuuviSensorDevice: { id: $id, name: $name, persisted: $persisted, macAddress: $macAddress, temperature: $temperature, humidity: $humidity, pressure: $pressure, acceleration: $acceleration, powerInfo: $powerInfo }";
  }
}
