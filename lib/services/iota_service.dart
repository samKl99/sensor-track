import 'package:retrofit/dio.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_delete_device_request_form.dart';
import 'package:sensor_track/repositories/iota_repository/src/forms/iota_new_device_request_form.dart';
import 'package:sensor_track/services/authentication_service.dart';
import 'package:sensor_track/services/bloc.dart';

class IotaService extends Bloc {
  final IotaClient _iotaClient;
  final AuthenticationService _authenticationService;

  IotaService(this._iotaClient, this._authenticationService);

  Future<List<IotaDevice>> getUserDevices() async {
    final user = _authenticationService.currentUser!;
    final devices = (await _iotaClient.iotaDeviceApi.getUserDevices(user.id, user.apiKey!)).data;
    return devices;
  }

  Future<HttpResponse> registerNewDevice(final IotaNewDeviceForm form) async {
    try {
      final user = _authenticationService.currentUser!;
      final newDeviceRequestForm = IotaNewDeviceRequestForm(apiKey: user.apiKey!, id: form.sensorId, device: form);
      return await _iotaClient.iotaDeviceApi.createNewDevice(newDeviceRequestForm);
    } catch (e) {
      rethrow;
    }
  }

  Future<HttpResponse> deleteDevice(final String deviceId) async {
    final user = _authenticationService.currentUser!;
    final deleteDeviceRequestForm = IotaDeleteDeviceRequestForm(apiKey: user.apiKey!, deviceId: deviceId);
    return await _iotaClient.iotaDeviceApi.deleteDevice(deleteDeviceRequestForm);
  }

  @override
  dispose() {
  }
}
