import 'package:dio/dio.dart';
import 'package:sensor_track/repositories/iota_repository/src/api/iota_data_api.dart';
import 'package:sensor_track/repositories/iota_repository/src/api/iota_device_api.dart';
import 'package:sensor_track/repositories/iota_repository/src/api/iota_user_api.dart';

import 'configurations/iota_configuration.dart';

class IotaClient {
  late String baseUrl;

  final dio = Dio();

  IotaDeviceApi get iotaDeviceApi => IotaDeviceApi(dio, baseUrl: baseUrl);

  IotaUserApi get iotaUserApi => IotaUserApi(dio, baseUrl: baseUrl);

  IotaDataApi get iotaDataApi => IotaDataApi(dio, baseUrl: baseUrl);

  IotaClient(IotaConfiguration configuration) {
    dio.options.headers["content-type"] = 'application/json';
    dio.options.headers["accept"] = 'application/json';

    configure(configuration);
  }

  void configure(IotaConfiguration configuration) {
    baseUrl = configuration.baseUrl;
  }
}
