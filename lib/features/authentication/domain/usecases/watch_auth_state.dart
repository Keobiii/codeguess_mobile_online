import 'package:codeguess/features/authentication/domain/entities/app_user.dart';
import 'package:codeguess/features/authentication/domain/repositories/auth_repository.dart';

class WatchAuthState {
  final AuthRepository repository;
  WatchAuthState(this.repository);

  Stream<AppUser?> call() => repository.authStateChanges();
}
