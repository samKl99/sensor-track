import 'package:sensor_track/models/sensor_device.dart';
import 'package:sensor_track/ruuvi/data_format_5_decoder.dart';
import 'package:sensor_track/ruuvi/ruuvi_acceleration.dart';
import 'package:sensor_track/ruuvi/ruuvi_power_info.dart';

class RuuviSensorDevice extends SensorDevice {
  double temperature;
  double humidity;
  int pressure;
  RuuviAcceleration acceleration;
  RuuviPowerInfo powerInfo;

  RuuviSensorDevice(
    int rssi,
    String id,
    String name,
    List<int> data,
  ) : super(
          rssi: rssi,
          id: id,
          name: name,
        ) {
    temperature = RuuviDataFormat5Decoder.getTemperature(data);
    humidity = RuuviDataFormat5Decoder.getHumidity(data);
    pressure = RuuviDataFormat5Decoder.getPressure(data);
    acceleration = RuuviDataFormat5Decoder.getAcceleration(data);
    powerInfo = RuuviDataFormat5Decoder.getPowerInfo(data);
  }
}
