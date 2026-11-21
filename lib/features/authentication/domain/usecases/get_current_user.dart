import 'package:codeguess/features/authentication/domain/entities/app_user.dart';
import 'package:codeguess/features/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  AppUser? call() => repository.getCurrentUser();
}
