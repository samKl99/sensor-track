class RuuviPowerInfo {
  /* battery in mV */
  final int? battery;

  /* transmit power in dBm */
  final int? txPower;

  const RuuviPowerInfo({
    this.battery = 0,
    this.txPower = 0,
  });

  @override
  String toString() {
    return "battery: $battery, txPower: $txPower";
  }
}
