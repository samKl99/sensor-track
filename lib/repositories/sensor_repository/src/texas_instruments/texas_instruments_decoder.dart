// see https://github.com/msaunby/ble-sensor-pi/blob/master/sensortag/sensor_calcs.py

class TexasInstrumentsDecoder {
  /* return temperature in celsius */
  static double? getTemperature(final List<int>? data) {
    if (_isDataInvalid(data)) {
      return null;
    }

    final rawAmbientTemperature = _toSigned((data![3] << 8) + data[2]);
    final ambientTemperature = rawAmbientTemperature / 128.0;

    return ambientTemperature;
  }

  /* return humidity in % */
  static double? getHumidity(final List<int>? data) {
    if (_isDataInvalid(data)) {
      return null;
    }

    final rawHumidity = (data![3] << 8) + data[2];
    final humidity = -6.0 + 125.0 / 65536.0 * (rawHumidity & ~0x0003);

    return humidity;
  }

  /* return temperature in pa */
  static int? getPressure(final List<int>? data, final List<int> calibrationData) {
    if (_isDataInvalid(data)) {
      return null;
    }

    final c3 = _bldInt(calibrationData[4], calibrationData[5]);
    final c4 = _bldInt(calibrationData[6], calibrationData[7]);
    final c5 = _toSigned(_bldInt(calibrationData[8], calibrationData[9]));
    final c6 = _toSigned(_bldInt(calibrationData[10], calibrationData[11]));
    final c7 = _toSigned(_bldInt(calibrationData[12], calibrationData[13]));
    final c8 = _toSigned(_bldInt(calibrationData[14], calibrationData[15]));

    final rawTemperature = _toSigned((data![1] << 8) + data[0]);
    final rawPressure = (data[3] << 8) + data[2];

    // Sensitivity
    int s = c3;
    int val = c4 * rawTemperature;
    s += (val >> 17);
    val = c5 * rawTemperature * rawTemperature;
    s += (val >> 34);

    // Offset
    int o = c6 << 14;
    val = c7 * rawTemperature;
    o += (val >> 3);
    val = c8 * rawTemperature * rawTemperature;
    o += (val >> 19);

    // Pressure (Pa)
    int pres = ((s * rawPressure) + o) >> 14;

    return pres;
  }

  static int _bldInt(final int loByte, final int hiByte) {
    return (loByte & 0x0FF) + ((hiByte & 0x0FF) << 8);
  }

  static int _toSigned(final int num) {
    return num > 0x7fff ? num - 0x10000 : num;
  }

  static _isDataInvalid(final List<int>? data) {
    return data == null || data.length < 4;
  }
}
