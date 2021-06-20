import 'package:hive/hive.dart';
import 'package:sensor_track/repositories/scan_repository/src/scan_repository.dart';
import 'package:sensor_track/services/authentication_service.dart';

import 'entities/scan_entity.dart';
import 'models/scan.dart';

class HiveScanRepository implements ScanRepository {
  static const _SCAN_HIVE_BOX_KEY = "SCAN_HIVE_KEY";
  final AuthenticationService _authenticationService;

  HiveScanRepository(this._authenticationService) {
    Hive.registerAdapter(ScanEntityAdapter());
  }

  String get _scanBoxId => "$_SCAN_HIVE_BOX_KEY\$${_authenticationService.currentUser?.id}";

  @override
  Future<void> addScan(final Scan scan) async {
    final _scanBox = await Hive.openBox(_scanBoxId);
    return _scanBox.put(scan.id, scan.toEntity());
  }

  @override
  Future<void> deleteScan(final Scan scan) async {
    final _scanBox = await Hive.openBox(_scanBoxId);
    return _scanBox.delete(scan.id);
  }

  @override
  Future<List<Scan>> scans({int limit = 100}) async {
    final _scanBox = await Hive.openBox(_scanBoxId);
    return _scanBox.values.take(limit).map((e) => Scan.fromEntity(e)).toList();
  }

  @override
  Future<void> updateScan(final Scan oldScan, final Scan newScan) async {
    final _scanBox = await Hive.openBox(_scanBoxId);
    return _scanBox.put(oldScan.id, newScan.toEntity());
  }
}
