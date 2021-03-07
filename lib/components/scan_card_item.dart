import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sensor_track/components/round_image.dart';
import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';
import 'package:sensor_track/util/date_util.dart';
import 'package:tinycolor/tinycolor.dart';

class ScanCardItem extends StatelessWidget {
  final Scan scan;

  const ScanCardItem(this.scan);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: TinyColor.fromString("#35374a").color,
        borderRadius: BorderRadius.circular(25.0),
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6.5,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
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
                    scan.sensorDeviceName,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                RoundImage(scan.sensorDeviceLogoURL),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 25.0,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.thermometerThreeQuarters,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${scan.temperature} ${String.fromCharCode($deg)}C",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Container(
                      width: 25.0,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.tint,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${scan.humidity} %",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Container(
                      width: 25.0,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.wind,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${scan.pressure} hPa",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Container(
                      width: 25.0,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.clock,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "${DateUtil.germanDateTimeFormatter.format(scan.createdAt)}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
