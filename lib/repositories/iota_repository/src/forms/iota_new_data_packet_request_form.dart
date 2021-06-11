import 'package:json_annotation/json_annotation.dart';

part 'iota_new_data_packet_request_form.g.dart';

@JsonSerializable()
class IotaNewDataPacketRequestForm {
  @JsonKey(name: "id")
  final String deviceId;

  @JsonKey(name: "sk")
  final String deviceSecret;
  final Map<String, dynamic> data;

  const IotaNewDataPacketRequestForm({
    required this.deviceId,
    required this.deviceSecret,
    required this.data,
  });

  factory IotaNewDataPacketRequestForm.fromJson(Map<String, dynamic> json) => _$IotaNewDataPacketRequestFormFromJson(json);

  Map<String, dynamic> toJson() => _$IotaNewDataPacketRequestFormToJson(this);
}
