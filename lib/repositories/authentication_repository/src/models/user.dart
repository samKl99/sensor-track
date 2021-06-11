import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String id;
  final String? email;
  String? apiKey;

  User({
    required this.id,
    this.email,
    this.apiKey,
  });

  static User fromFirebaseUser(final firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }
}
