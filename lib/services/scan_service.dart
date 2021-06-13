import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';
import 'package:sensor_track/repositories/scan_repository/src/scan_repository.dart';
import 'package:sensor_track/repositories/sensor_repository/sensor_repository.dart';
import 'package:sensor_track/services/bloc.dart';
import 'package:sensor_track/services/iota_service.dart';

class ScanService extends Bloc {
  late ScanRepository _scanRepository;
  late IotaService _iotaService;

  ScanService(this._scanRepository, this._iotaService);

  Stream<List<Scan>> get scans => _scans.stream;

  Stream<bool> get scansLoading => _scansLoading.stream;

  Stream<bool> get scanSaving => _scanSaving.stream;

  final _scans = BehaviorSubject<List<Scan>>.seeded([]);
  final _scansLoading = BehaviorSubject<bool>.seeded(false);

  final _scanSaving = BehaviorSubject<bool>.seeded(false);

  getLastScans({int limit = 15}) async {
    _scansLoading.add(true);
    try {
      _scans.add(await _scanRepository.scans(limit: limit));
    } catch (e) {
      _scans.addError("error loading last scans");
    } finally {
      _scansLoading.add(false);
    }
  }

  Future<void> addScan(final Sensor sensor, final Scan scan) async {
    _scanSaving.add(true);
    try {
      await _iotaService.createNewDataPacketFromScan(sensor, scan);
      await _scanRepository.addScan(scan);
    } catch (e) {
      print(e);
    } finally {
      _scanSaving.add(false);
    }
  }

  Future<void> deleteScan(final Scan scan) async {
    await _scanRepository.deleteScan(scan);
  }

  List<Scan> _getMockScans() {
    return List.generate(
      15,
      (index) => Scan(
        temperature: 30.7,
        humidity: 23.1,
        pressure: 1753,
        createdAt: DateTime.now(),
        sensorDeviceName: index % 2 == 0 ? "Sensor 1" : "Sensor 2",
        sensorDeviceLogoURL: index % 2 == 0 ? "assets/sensor-icons/repositories.sensor_repository.src.ruuvi.png" : "assets/sensor-icons/texas_instruments.png",
      ),
    );
  }

  @override
  dispose() {
    _scans.drain();
    _scans.close();

    _scansLoading.drain();
    _scansLoading.close();

    _scanSaving.drain();
    _scanSaving.close();
  }
}
