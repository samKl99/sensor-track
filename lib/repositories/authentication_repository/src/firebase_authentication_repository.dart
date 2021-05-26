import 'package:sensor_track/repositories/authentication_repository/src/authentication_repository.dart';
import 'package:sensor_track/repositories/authentication_repository/src/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  const FirebaseAuthenticationRepository({required firebase_auth.FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> getUser() async {
    if (_firebaseAuth.currentUser != null) {
      return User.fromFirebaseUser(_firebaseAuth.currentUser!);
    } else {
      return null;
    }
  }

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      }
      if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      throw LoginException();
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> registerWithEmailAndPassword(final String email, final String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw PasswordToWeakException();
      }
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseException();
      }
    } catch (e) {
      throw RegistrationException();
    }
  }
}

class PasswordToWeakException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class RegistrationException implements Exception {}

class LoginException implements Exception {}
