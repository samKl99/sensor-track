import 'package:json_annotation/json_annotation.dart';

part 'iota_user.g.dart';

@JsonSerializable()
class IotaUser {
  final String apiKey;
  final int numberOfDevices;

  const IotaUser({
    required this.apiKey,
    required this.numberOfDevices,
  });

  factory IotaUser.fromJson(Map<String, dynamic> json) => _$IotaUserFromJson(json);

  Map<String, dynamic> toJson() => _$IotaUserToJson(this);
}