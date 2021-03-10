import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';

abstract class ScanRepository {
  Future<void> addScan(Scan scan);

  Future<void> deleteScan(Scan scan);

  List<Scan> scans({int limit});

  Future<void> updateScan(Scan oldScan, Scan newScan);
}
