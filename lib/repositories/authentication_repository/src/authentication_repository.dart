import 'models/user.dart';

abstract class AuthenticationRepository {

  Future<void> registerWithEmailAndPassword(final String email, final String password);

  Future<void> loginWithEmailAndPassword(final String email, final String password);

  Future<void> loginWithGoogle();

  Future<void> logout();

  Future<User?> getUser();
}
