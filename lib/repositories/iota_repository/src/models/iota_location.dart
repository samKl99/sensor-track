import 'package:json_annotation/json_annotation.dart';

part 'iota_location.g.dart';

@JsonSerializable()
class IotaLocation {
  final String? city;
  final String? country;

  const IotaLocation({
    this.city,
    this.country,
  });

  factory IotaLocation.fromJson(Map<String, dynamic> json) => _$IotaLocationFromJson(json);

  Map<String, dynamic> toJson() => _$IotaLocationToJson(this);
}