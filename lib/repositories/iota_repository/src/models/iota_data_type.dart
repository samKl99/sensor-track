import 'package:json_annotation/json_annotation.dart';

part 'iota_data_type.g.dart';

@JsonSerializable()
class IotaDataType {
  final String id;
  final String unit;
  final String name;

  @JsonKey(ignore: true)
  bool active;

  IotaDataType({
    required this.id,
    required this.unit,
    required this.name,
    this.active = true,
  });

  factory IotaDataType.fromJson(Map<String, dynamic> json) => _$IotaDataTypeFromJson(json);

  Map<String, dynamic> toJson() => _$IotaDataTypeToJson(this);
}