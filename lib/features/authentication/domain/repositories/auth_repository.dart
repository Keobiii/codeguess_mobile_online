import 'package:codeguess/features/authentication/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn(String email, String password);

  Future<AppUser> signUp(String displayName, String email, String password);

  Future<void> signOut();

  AppUser? getCurrentUser();

  Stream<AppUser?> authStateChanges();
}
