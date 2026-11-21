import 'package:codeguess/features/authentication/domain/entities/app_user.dart';
import 'package:codeguess/features/authentication/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<AppUser> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
