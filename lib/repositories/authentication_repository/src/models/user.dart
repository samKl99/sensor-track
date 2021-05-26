import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String id;
  final String? email;

  const User({
    required this.id,
    this.email,
  });

  static User fromFirebaseUser(final firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }
}
