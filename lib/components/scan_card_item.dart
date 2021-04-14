import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sensor_track/components/round_image.dart';
import 'package:sensor_track/components/sensor_track_card.dart';
import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';
import 'package:sensor_track/util/converter_util.dart';
import 'package:sensor_track/util/date_util.dart';

class ScanCardItem extends StatelessWidget {
  final Scan scan;
  final VoidCallback? onTap;

  const ScanCardItem({
    required this.scan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SensorTrackCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Text(
                    scan.sensorDeviceName != null ? scan.sensorDeviceName! : "",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                scan.sensorDeviceLogoURL != null ? RoundImage(scan.sensorDeviceLogoURL!) : Container(),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Column(
              children: [
                _temperatureRow,
                const SizedBox(
                  height: 8.0,
                ),
                _humidityRow,
                const SizedBox(
                  height: 8.0,
                ),
                _pressureRow,
                const SizedBox(
                  height: 8.0,
                ),
                _createdAtRow
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _temperatureRow => _buildScanDataRow(FontAwesomeIcons.thermometerThreeQuarters, Colors.orange,
      "${scan.temperature != null ? scan.temperature! : "-"} ${String.fromCharCode($deg)}C");

  Widget get _humidityRow =>
      _buildScanDataRow(FontAwesomeIcons.tint, Colors.blueAccent, "${scan.humidity != null ? scan.humidity! : "-"} %");

  Widget get _pressureRow => _buildScanDataRow(
      FontAwesomeIcons.wind, Colors.white70, "${scan.pressure != null ? ConverterUtil.fromPaToHPa(scan.pressure!) : "-"} hPa");

  Widget get _createdAtRow => _buildScanDataRow(
      FontAwesomeIcons.clock, Colors.grey, scan.createdAt != null ? "${DateUtil.germanDateTimeFormatter.format(scan.createdAt!)}" : "");

  Widget _buildScanDataRow(final IconData iconData, final Color iconColor, final String dataString) {
    return Row(
      children: [
        Container(
          width: 25.0,
          child: Center(
            child: FaIcon(
              iconData,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          dataString,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
