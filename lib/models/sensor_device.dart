import 'package:sensor_track/services/sensor_service.dart';

class SensorDevice {
  final String id;
  String name;
  String logoURL;
  bool persisted;

  SensorDevice({this.id, this.name, this.logoURL, this.persisted}) {
    logoURL = logoURL ?? SensorService.getLogoImageForSensor(this);
  }
}
