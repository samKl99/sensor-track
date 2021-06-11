import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_delete_device_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_new_device_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/models/iota_device.dart';

part 'iota_device_api.g.dart';

@RestApi()
abstract class IotaDeviceApi {
  factory IotaDeviceApi(Dio dio, {String baseUrl}) = _IotaDeviceApi;

  /// Get user devices
  @GET('/devices')
  Future<HttpResponse<List<IotaDevice>>> getUserDevices(
    @Query('userId') String userId,
    @Query('apiKey') String apiKey,
  );

  /// Create new device
  @POST('/newDevice')
  Future<HttpResponse> createNewDevice(@Body() IotaNewDeviceRequestForm form);

  /// delete device by id
  @DELETE('/delete')
  Future<HttpResponse> deleteDevice(@Body() IotaDeleteDeviceRequestForm form);
}
