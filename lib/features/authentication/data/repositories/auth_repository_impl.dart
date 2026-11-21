import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AppUser> signIn(String email, String password) {
    return _guard(() => remoteDataSource.signIn(email, password));
  }

  @override
  Future<AppUser> signUp(String displayName, String email, String password) {
    return _guard(() => remoteDataSource.signUp(displayName, email, password));
  }

  @override
  Future<void> signOut() => _guard(() => remoteDataSource.signOut());

  @override
  AppUser? getCurrentUser() => remoteDataSource.getCurrentUser();

  @override
  Stream<AppUser?> authStateChanges() => remoteDataSource.authStateChanges();

  /// Runs a call and converts any error into an [AuthFailure].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthException catch (e) {
      throw AuthFailure(_messageFor(e));
    } catch (_) {
      throw const AuthFailure(
        'Something went wrong. Check your connection and try again.',
      );
    }
  }

  String _messageFor(AuthException e) {
    switch (e.code) {
      case 'invalid_credentials':
        return 'Invalid email or password.';
      case 'user_already_exists':
      case 'email_exists':
        return 'An account with this email already exists.';
      case 'weak_password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email_not_confirmed':
        return 'Please confirm your email before logging in.';
      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'validation_failed':
        return 'Please enter a valid email address.';
    }

    if (e.message.contains('Database error saving new user')) {
      return 'Could not create your profile. Please try again.';
    }
    return e.message;
  }
}
