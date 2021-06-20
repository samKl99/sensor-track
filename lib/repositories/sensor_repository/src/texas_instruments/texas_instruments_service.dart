import 'package:flutter_blue/flutter_blue.dart';
import 'package:collection/collection.dart';
import 'package:sensor_track/repositories/sensor_repository/src/texas_instruments/texas_instruments_decoder.dart';

import 'texas_instruments_service_id.dart';

class TexasInstrumentsService {
  // Temperature
  Future<Stream<double?>?> enableTemperature(final BluetoothDevice device) async {
    final temperatureStream = await _toggleTemperature(device, true);
    return temperatureStream?.map((data) => TexasInstrumentsDecoder.getTemperature(data));
  }

  disableTemperature(final BluetoothDevice device) async {
    await _toggleTemperature(device, false);
  }

  Future<Stream<List<int>?>?> _toggleTemperature(final BluetoothDevice device, final bool enable) async {
    return await _toggleService(device, TexasInstrumentsServiceId.TEMPERATURE_UUID, TexasInstrumentsServiceId.TEMPERATURE_CONFIG_UUID,
        TexasInstrumentsServiceId.TEMPERATURE_DATA_UUID, enable);
  }

  // Humidity
  Future<Stream<double?>?> enableHumidity(final BluetoothDevice device) async {
    final humidityStream = await _toggleHumidity(device, true);
    return humidityStream?.map((data) => TexasInstrumentsDecoder.getHumidity(data));
  }

  disableHumidity(final BluetoothDevice device) async {
    await _toggleHumidity(device, false);
  }

  Future<Stream<List<int>?>?> _toggleHumidity(final BluetoothDevice device, final bool enable) async {
    return await _toggleService(device, TexasInstrumentsServiceId.HUMIDITY_UUID, TexasInstrumentsServiceId.HUMIDITY_CONFIG_UUID,
        TexasInstrumentsServiceId.HUMIDITY_DATA_UUID, enable);
  }

  // Pressure
  Future<Stream<int?>?> enablePressure(final BluetoothDevice device) async {
    final pressureCalibrationData = await _getPressureCalibrationData(device);
    if (pressureCalibrationData == null) {
      throw "no pressure calibration data available";
    }

    final humidityStream = await _togglePressure(device, true);

    return humidityStream?.map((data) => TexasInstrumentsDecoder.getPressure(data, pressureCalibrationData));
  }

  disablePressure(final BluetoothDevice device) async {
    await _togglePressure(device, false);
  }

  Future<Stream<List<int>?>?> _togglePressure(final BluetoothDevice device, final bool enable) async {
    return await _toggleService(device, TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_UUID,
        TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_CONFIG_UUID, TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_DATA_UUID, enable);
  }

  Future<List<int>?> _getPressureCalibrationData(final BluetoothDevice device) async {
    final service = await _getServiceById(device, TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_UUID);

    if (service != null) {
      final configCharacteristics = _getCharacteristicsById(service, TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_CONFIG_UUID);
      final dataCharacteristics = _getCharacteristicsById(service, TexasInstrumentsServiceId.BAROMETRIC_PRESSURE_CALIBRATION_UUID);

      if (configCharacteristics != null) {
        await configCharacteristics.write([0x02]);
      }

      if (dataCharacteristics != null) {
        final pressureCalibrationData = await dataCharacteristics.read();

        return pressureCalibrationData;
      }
    }
  }

  Future<Stream<List<int>>?> _toggleService(final BluetoothDevice device, final String serviceId, final String serviceConfigId,
      final String serviceDataId, final bool enable) async {
    final service = await _getServiceById(device, serviceId);
    if (service != null) {
      final configCharacteristics = _getCharacteristicsById(service, serviceConfigId);
      final dataCharacteristics = _getCharacteristicsById(service, serviceDataId);

      if (configCharacteristics != null) {
        if (enable) {
          await _enableConfigCharacteristic(configCharacteristics);

          if (dataCharacteristics != null) {
            await dataCharacteristics.setNotifyValue(true);

            return dataCharacteristics.value;
          }
        } else {
          await _disableConfigCharacteristic(configCharacteristics);
        }
      }
    }
  }

  Future<BluetoothService?> _getServiceById(final BluetoothDevice device, final String serviceId) async {
    final services = await device.discoverServices();
    return services.firstWhereOrNull((element) => element.uuid == Guid(serviceId));
  }

  BluetoothCharacteristic? _getCharacteristicsById(final BluetoothService service, final String characteristicsId) {
    return service.characteristics.firstWhereOrNull((element) => element.uuid == Guid(characteristicsId));
  }

  _enableConfigCharacteristic(final BluetoothCharacteristic characteristic) async {
    await characteristic.write([0x01]);
  }

  _disableConfigCharacteristic(final BluetoothCharacteristic characteristic) async {
    await characteristic.write([0x00]);
  }
}
