import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_new_data_packet_request_form.dart';

part 'iota_data_api.g.dart';

@RestApi()
abstract class IotaDataApi {
  factory IotaDataApi(Dio dio, {String baseUrl}) = _IotaDataApi;

  /// Create new data packet
  @POST('/newDataPacket')
  Future<HttpResponse> createNewDataPacket(@Body() IotaNewDataPacketRequestForm form);
}
