import 'package:codeguess/features/authentication/domain/entities/app_user.dart';
import 'package:codeguess/features/authentication/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<AppUser> call({
    required String displayName,
    required String email,
    required String password,
  }) {
    return repository.signUp(displayName, email, password);
  }
}
