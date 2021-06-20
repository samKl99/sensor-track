import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:sensor_track/repositories/authentication_repository/src/authentication_repository.dart';
import 'package:sensor_track/repositories/authentication_repository/src/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  @override
  Future<void> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    if (googleAuth != null) {
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    }
  }

  @override
  Future<void> loginWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = firebase_auth.OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    await _firebaseAuth.signInWithCredential(oauthCredential);
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class PasswordToWeakException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class RegistrationException implements Exception {}

class LoginException implements Exception {}
