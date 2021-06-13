import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/services/bloc.dart';

class LocationService extends Bloc {
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _position = BehaviorSubject<Position?>.seeded(null);

  Stream<Position?> get position => _position.stream;

  bool _isInitialized = false;

  LocationService() {
    _init();
  }

  _init() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    _isInitialized = true;
  }

  void listenLocation() {
    if (!_isInitialized) {
      throw "not initialized";
    }

    _determinePositionAsStream().listen((event) {
      if (!_position.isClosed) {
        _position.add(event);
      }
    });
  }

  Stream<Position> _determinePositionAsStream() {
    if (!_isInitialized) {
      throw "Not initialized";
    }

    return Geolocator.getPositionStream();
  }

  @override
  dispose() {
    _position.drain();
    _position.close();

    _loading.drain();
    _loading.close();
  }
}
