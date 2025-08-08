import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Logs in a user with [email] and [password] and returns a [UserModel].
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Registers a new user with [name], [email], and [password] and returns a [UserModel].
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logs out the user (e.g. clear session, tokens, etc.)
  Future<void> logout();
}
