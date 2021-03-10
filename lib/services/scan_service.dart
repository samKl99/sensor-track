import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/repositories/scan_repository/src/models/scan.dart';
import 'package:sensor_track/repositories/scan_repository/src/scan_repository.dart';
import 'package:sensor_track/services/bloc.dart';

class ScanService extends Bloc {
  ScanRepository _scanRepository;

  ScanService(this._scanRepository);

  Stream<List<Scan>> get scans => _scans.stream;

  Stream<bool> get scansLoading => _scansLoading.stream;

  final _scans = BehaviorSubject<List<Scan>>.seeded([]);
  final _scansLoading = BehaviorSubject<bool>.seeded(false);

  getLastScans({int limit = 15}) {
    _scansLoading.add(true);
    try {
      _scans.add(_scanRepository.scans(limit: limit));
    } catch (e) {
      _scans.addError("error loading last scans");
    } finally {
      _scansLoading.add(false);
    }
  }

  void addScan(final Scan scan) {
    _scanRepository.addScan(scan);
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
        sensorDeviceLogoURL:
            index % 2 == 0 ? "assets/sensor-icons/ruuvi.png" : "assets/sensor-icons/texas_instruments.png",
      ),
    );
  }

  @override
  dispose() {
    _scans.drain();
    _scans.close();

    _scansLoading.drain();
    _scansLoading.close();
  }
}
