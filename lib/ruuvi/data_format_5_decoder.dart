import 'package:sensor_track/ruuvi/ruuvi_acceleration.dart';
import 'package:sensor_track/ruuvi/ruuvi_power_info.dart';

/* Decoder for Ruuvi data format 5 (https://github.com/ruuvi/ruuvi-sensor-protocols/blob/master/dataformat_05.md) */
class RuuviDataFormat5Decoder {
  /* return temperature in celsius */
  static double? getTemperature(final List<int> data) {
    if (data[1] == 0x7FFF) {
      return null;
    }

    final temperature = _twosComplement((data[1] << 8) + data[2], 16) / 200;
    return temperature;
  }

  /* return humidity % */
  static double? getHumidity(final List<int> data) {
    if (data[3] == 0x7FFF) {
      return null;
    }

    return ((data[3] & 0xFF) << 8 | data[4] & 0xFF) / 400;
  }

  /* return air pressure hPa */
  static int? getPressure(final List<int> data) {
    if (data[5] == 0x7FFF) {
      return null;
    }

    return ((data[5] & 0xFF) << 8 | data[6] & 0xFF) + 50000;
  }

  /* return acceleration mG */
  static RuuviAcceleration? getAcceleration(final List<int> data) {
    if (data[7] == 0x7FFF || data[9] == 0x7FFF || data[11] == 0x7FFF) {
      return null;
    }

    final accX = _twosComplement((data[7] << 8) + data[8], 16);
    final accY = _twosComplement((data[9] << 8) + data[10], 16);
    final accZ = _twosComplement((data[11] << 8) + data[12], 16);

    return RuuviAcceleration(
      accelerationX: accX,
      accelerationY: accY,
      accelerationZ: accZ,
    );
  }

  /* return RuuviPowerInfo (battery voltage, tx power) */
  static RuuviPowerInfo? getPowerInfo(final List<int> data) {
    final powerInfo = (data[13] & 0xFF) << 8 | (data[14] & 0xFF);
    int? battery = _rShift(powerInfo, 5) + 1600;
    int? txPower = (powerInfo & 0x1F) * 2 - 40;

    if (_rShift(powerInfo, 5) == 0x7FF) {
      battery = null;
    }

    if ((powerInfo & 0x1F) == 0x1F) {
      txPower = null;
    }

    return RuuviPowerInfo(
      txPower: txPower,
      battery: battery,
    );
  }

  static int getMovementCounter(final List<int> data) {
    return data[15] & 0xFF;
  }

  static int getMeasurementSequenceNumber(final List<int> data) {
    return (data[16] & 0xFF) << 8 | data[17] & 0xFF;
  }

  static String getMACAddress(final List<int> data) {
    return [_int2Hex(data[18]), _int2Hex(data[19]), _int2Hex(data[20]), _int2Hex(data[21]), _int2Hex(data[22]), _int2Hex(data[23])]
        .join(':');
  }

  static int _twosComplement(int value, final int bits) {
    if ((value & (1 << (bits - 1))) != 0) {
      value = value - (1 << bits);
    }
    return value;
  }

  static int _rShift(final int value, final int amount) {
    return (value & 0xFFFF) >> amount;
  }

  static String _int2Hex(final int value) {
    return value.toRadixString(16).toUpperCase();
  }
}
