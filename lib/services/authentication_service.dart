import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/repositories/authentication_repository/authentication_repository.dart';
import 'package:sensor_track/services/bloc.dart';

class AuthenticationService extends Bloc {
  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository;

  final _user = BehaviorSubject<User?>.seeded(null);

  Stream<User?> get user => _user.stream;

  User? get currentUser => _user.value;

  AuthenticationService(this._firebaseAuthenticationRepository);

  Future<void> isUserAuthenticated() async {
    final user = await _firebaseAuthenticationRepository.getUser();
    if (user != null) {
      _user.add(user);
    } else {
      _user.add(null);
    }
  }

  Future<void> login(final String email, final String password) async {
    try {
      await _firebaseAuthenticationRepository.loginWithEmailAndPassword(email, password);
      _user.add(await _firebaseAuthenticationRepository.getUser());
    } catch (e) {
      _user.addError("can't login user");
      rethrow;
    }
  }

  Future<void> register(final String email, final String password) async {
    try {
      await _firebaseAuthenticationRepository.registerWithEmailAndPassword(email, password);
      _user.add(await _firebaseAuthenticationRepository.getUser());
    } catch (e) {
      _user.addError("can't register user");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuthenticationRepository.logout();
    _user.add(null);
  }

  @override
  dispose() {
    _user.drain();
    _user.close();
  }
}
