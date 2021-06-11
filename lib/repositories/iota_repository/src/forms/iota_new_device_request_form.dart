import 'package:json_annotation/json_annotation.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';

part 'iota_new_device_request_form.g.dart';

@JsonSerializable()
class IotaNewDeviceRequestForm {
  final String apiKey;
  final String id;
  final IotaNewDeviceForm device;

  const IotaNewDeviceRequestForm({
    required this.device,
    required this.apiKey,
    required this.id,
  });

  factory IotaNewDeviceRequestForm.fromJson(Map<String, dynamic> json) => _$IotaNewDeviceRequestFormFromJson(json);

  Map<String, dynamic> toJson() => _$IotaNewDeviceRequestFormToJson(this);
}
