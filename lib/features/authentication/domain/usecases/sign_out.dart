import 'package:codeguess/features/authentication/domain/repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;
  SignOut(this.repository);

  Future<void> call() => repository.signOut();
}
