import 'package:sensor_track/repositories/iota_repository/src/enums/iota_data_fields_enum.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';

class IotaDataFieldsMapper {
  Map<String, dynamic> populate(final Scan scan) {
    final Map<String, dynamic> data = Map();

    if (scan.temperature != null) {
      data[IotaDataFieldsEnum.temperatureKey] = scan.temperature;
    }

    if (scan.humidity != null) {
      data[IotaDataFieldsEnum.humidityKey] = scan.humidity;
    }

    if (scan.pressure != null) {
      data[IotaDataFieldsEnum.pressureKey] = scan.pressure;
    }

    return data;
  }
}
