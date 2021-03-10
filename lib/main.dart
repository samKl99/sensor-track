import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensor_track/sensor_track.dart';

void main() async {
  await Hive.initFlutter();
  runApp(SensorTrack());
}
