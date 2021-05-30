import 'package:json_annotation/json_annotation.dart';

part 'iota_data_type.g.dart';

@JsonSerializable()
class IotaDataType {
  String? id;
  String? unit;
  String? name;

  IotaDataType({
    this.id,
    this.unit,
    this.name,
  });

  factory IotaDataType.fromJson(Map<String, dynamic> json) => _$IotaDataTypeFromJson(json);

  Map<String, dynamic> toJson() => _$IotaDataTypeToJson(this);
}