import 'package:json_annotation/json_annotation.dart';

part 'iota_delete_device_request_form.g.dart';

@JsonSerializable()
class IotaDeleteDeviceRequestForm {
  final String apiKey;
  final String deviceId;

  const IotaDeleteDeviceRequestForm({
    required this.apiKey,
    required this.deviceId,
  });

  factory IotaDeleteDeviceRequestForm.fromJson(Map<String, dynamic> json) => _$IotaDeleteDeviceRequestFormFromJson(json);

  Map<String, dynamic> toJson() => _$IotaDeleteDeviceRequestFormToJson(this);
}
