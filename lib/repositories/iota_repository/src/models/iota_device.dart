import 'package:json_annotation/json_annotation.dart';
import 'package:sensor_track/repositories/iota_repository/src/models/iota_data_type.dart';
import 'package:sensor_track/repositories/iota_repository/src/models/iota_location.dart';
import 'package:sensor_track/repositories/iota_repository/src/util/iota_date_util.dart';

part 'iota_device.g.dart';

@JsonSerializable()
class IotaDevice {
  final String? company;
  final String? type;
  @JsonKey(fromJson: IotaDateUtil.dateFromJson, toJson: IotaDateUtil.dateToJson)
  final DateTime? date;
  final int? price;
  final int? timestamp;
  final double? lat;
  final double? lon;
  final String? sensorId;
  final String? address;
  final bool? inactive;
  final String? owner;
  final IotaLocation? location;
  final List<IotaDataType>? dataTypes;
  final String? sk;

  const IotaDevice({
    this.company,
    this.timestamp,
    this.type,
    this.date,
    this.price,
    this.lat,
    this.lon,
    this.sensorId,
    this.address,
    this.inactive,
    this.owner,
    this.location,
    this.dataTypes,
    this.sk,
  });

  factory IotaDevice.fromJson(Map<String, dynamic> json) => _$IotaDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$IotaDeviceToJson(this);
}
