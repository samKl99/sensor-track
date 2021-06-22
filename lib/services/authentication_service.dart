import 'package:rxdart/rxdart.dart';
import 'package:sensor_track/repositories/authentication_repository/authentication_repository.dart';
import 'package:sensor_track/repositories/iota_repository/iota_repository.dart';
import 'package:sensor_track/services/bloc.dart';

class AuthenticationService extends Bloc {
  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository;
  final IotaClient _iotaClient;

  final _user = BehaviorSubject<User?>.seeded(null);
  final _isAuthenticating = BehaviorSubject<bool>.seeded(false);

  Stream<User?> get user => _user.stream;

  Stream<bool> get isAuthenticating => _isAuthenticating.stream;

  User? get currentUser => _user.value;

  AuthenticationService(this._firebaseAuthenticationRepository, this._iotaClient);

  Future<void> isUserAuthenticated() async {
    _isAuthenticating.add(true);
    final user = await _firebaseAuthenticationRepository.getUser();
    if (user != null) {
      _user.add(await _fetchUserData(user));
    } else {
      _user.add(null);
    }
    _isAuthenticating.add(false);
  }

  Future<void> login(final String email, final String password) async {
    try {
      _isAuthenticating.add(true);
      await _firebaseAuthenticationRepository.loginWithEmailAndPassword(email, password);
      await _populateUser();
    } catch (e) {
      _user.addError("can't login user with email and password");
      rethrow;
    } finally {
      _isAuthenticating.add(false);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      _isAuthenticating.add(true);
      await _firebaseAuthenticationRepository.loginWithGoogle();
      await _populateUser();
    } catch (e) {
      _user.addError("can't login user with google auth");
      rethrow;
    } finally {
      _isAuthenticating.add(false);
    }
  }

  Future<void> loginWithApple() async {
    try {
      _isAuthenticating.add(true);
      await _firebaseAuthenticationRepository.loginWithApple();
      await _populateUser();
    } catch (e) {
      print(e);
      _user.addError("can't login user with apple auth");
      rethrow;
    } finally {
      _isAuthenticating.add(false);
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

  Future<void> _populateUser() async {
    final user = await _firebaseAuthenticationRepository.getUser();
    if (user != null) {
      _user.add(await _fetchUserData(user));
    } else {
      _user.add(null);
    }
  }

  Future<User> _fetchUserData(final User user) async {
    try {
      final iotaUser = await _iotaClient.iotaUserApi.getUser(user.id);
      user.apiKey = iotaUser.data.apiKey;
    } catch (e) {
      // ignore silently
    }

    return user;
  }

  Future<void> logout() async {
    await _firebaseAuthenticationRepository.logout();
    _user.add(null);
  }

  @override
  dispose() {
    _user.drain();
    _user.close();

    _isAuthenticating.drain();
    _isAuthenticating.close();
  }
}
