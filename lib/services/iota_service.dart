import 'package:retrofit/dio.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_delete_device_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_new_data_packet_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_new_device_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/mappers/iota_data_fields_mapper.dart';
import 'package:sensor_track/repositories/scan_repository/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/bloc.dart';

class IotaService extends Bloc {
  final IotaClient _iotaClient;
  final AuthenticationService _authenticationService;

  IotaService(this._iotaClient, this._authenticationService);

  /* Devices */
  Future<List<IotaDevice>> getUserDevices() async {
    final user = _authenticationService.currentUser!;
    final devices = (await _iotaClient.iotaDeviceApi.getUserDevices(user.id, user.apiKey!)).data;
    return devices;
  }

  Future<HttpResponse> registerNewDevice(final IotaNewDeviceForm form) async {
    final user = _authenticationService.currentUser!;
    final newDeviceRequestForm = IotaNewDeviceRequestForm(apiKey: user.apiKey!, id: form.sensorId, device: form);
    return await _iotaClient.iotaDeviceApi.createNewDevice(newDeviceRequestForm);
  }

  Future<HttpResponse> deleteDevice(final String deviceId) async {
    final user = _authenticationService.currentUser!;
    final deleteDeviceRequestForm = IotaDeleteDeviceRequestForm(apiKey: user.apiKey!, deviceId: deviceId);
    return await _iotaClient.iotaDeviceApi.deleteDevice(deleteDeviceRequestForm);
  }

  /* Data */
  Future<HttpResponse> createNewDataPacketFromScan(final Sensor sensor, final Scan scan) async {
    try {
      if (sensor.iotaDeviceId == null || sensor.iotaSk == null) {
        throw "Set all required fields";
      } else {
        final dataMap = IotaDataFieldsMapper().populate(scan);
        return await _createNewDataPacket(sensor.iotaDeviceId!, sensor.iotaSk!, dataMap);
      }
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<HttpResponse> _createNewDataPacket(final String deviceId, final String deviceSecret, final Map<String, dynamic> data) async {
    final IotaNewDataPacketRequestForm form = IotaNewDataPacketRequestForm(
      deviceId: deviceId,
      deviceSecret: deviceSecret,
      data: data,
    );

    return await _iotaClient.iotaDataApi.createNewDataPacket(form);
  }

  @override
  dispose() {}
}
