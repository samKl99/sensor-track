import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sensor_track/repositories/iota_repository/src/models/iota_user.dart';

part 'iota_user_api.g.dart';

@RestApi()
abstract class IotaUserApi {
  factory IotaUserApi(Dio dio, {String baseUrl}) = _IotaUserApi;

  /// Get user devices
  @GET('/user')
  Future<HttpResponse<IotaUser>> getUser(@Query('userId') String userId);
}
