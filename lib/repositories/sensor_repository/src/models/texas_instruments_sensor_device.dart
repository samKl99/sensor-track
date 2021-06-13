import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/src/models/sensor_type.dart';

class TexasInstrumentsSensorDevice extends Sensor {
  TexasInstrumentsSensorDevice({
    required String id,
    required String name,
    double? temperature,
    double? humidity,
    int? pressure,
  }) : super(
          id: id,
          type: SensorType.TEXAS_INSTRUMENTS,
          name: name,
          temperature: temperature,
          humidity: humidity,
          pressure: pressure,
        );
}
