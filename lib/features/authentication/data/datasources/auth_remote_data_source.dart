import 'package:codeguess/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);

  Future<UserModel> signUp(String displayName, String email, String password);

  Future<void> signOut();

  UserModel? getCurrentUser();

  Stream<UserModel?> authStateChanges();
}
