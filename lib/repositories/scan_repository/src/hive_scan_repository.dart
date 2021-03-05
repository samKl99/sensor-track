import 'package:hive/hive.dart';
import 'package:sensor_track/repositories/scan_repository/src/scan_repository.dart';

import 'entities/scan_entity.dart';
import 'models/scan.dart';

class HiveScanRepository implements ScanRepository {
  static const SCAN_HIVE_BOX_KEY = "SCAN_HIVE_KEY";
  Box<ScanEntity> _scanBox;

  HiveScanRepository() {
    Hive.registerAdapter(ScanEntityAdapter());
  }

  Future<HiveScanRepository> init() async {
    _scanBox = await Hive.openBox(SCAN_HIVE_BOX_KEY);
    return this;
  }

  @override
  Future<void> addScan(final Scan scan) {
    if (_scanBox == null) {
      throw "Scan Box not initialized";
    }
    return _scanBox.put(scan.id, scan.toEntity());
  }

  @override
  Future<void> deleteScan(final Scan scan) {
    if (_scanBox == null) {
      throw "Scan Box not initialized";
    }
    return _scanBox.delete(scan.id);
  }

  @override
  List<Scan> scans({int limit = 100}) {
    if (_scanBox == null) {
      throw "Scan Box not initialized";
    }
    return _scanBox.values.take(limit).map((e) => Scan.fromEntity(e)).toList();
  }

  @override
  Future<void> updateScan(final Scan oldScan, final Scan newScan) {
    if (_scanBox == null) {
      throw "Scan Box not initialized";
    }
    return _scanBox.put(oldScan.id, newScan.toEntity());
  }
}
