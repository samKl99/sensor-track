import 'package:json_annotation/json_annotation.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/repositories/iota_repository/src/util/iota_date_util.dart';

part 'iota_new_device_form.g.dart';

@JsonSerializable()
class IotaNewDeviceForm {
  final String company;
  final String type;
  @JsonKey(fromJson: IotaDateUtil.dateFromJson, toJson: IotaDateUtil.dateToJson)
  final DateTime? date;
  final int price;
  final double lat;
  final double lon;
  final String sensorId;
  final bool inactive;
  final String owner;
  final IotaLocation location;
  final List<IotaDataType> dataTypes;

  const IotaNewDeviceForm({
    required this.company,
    required this.type,
    this.date,
    required this.price,
    required this.lat,
    required this.lon,
    required this.sensorId,
    required this.inactive,
    required this.owner,
    required this.location,
    required this.dataTypes,
  });

  factory IotaNewDeviceForm.fromJson(Map<String, dynamic> json) => _$IotaNewDeviceFormFromJson(json);

  Map<String, dynamic> toJson() => _$IotaNewDeviceFormToJson(this);
}
