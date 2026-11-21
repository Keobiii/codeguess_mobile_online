import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codeguess/core/providers/supabase_provider.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_remote_data_source_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/watch_auth_state.dart';

// Data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

// Use cases
final signInProvider = Provider<SignIn>((ref) {
  return SignIn(ref.watch(authRepositoryProvider));
});

final signUpProvider = Provider<SignUp>((ref) {
  return SignUp(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final watchAuthStateProvider = Provider<WatchAuthState>((ref) {
  return WatchAuthState(ref.watch(authRepositoryProvider));
});

// Current user, updated live (null = signed out)
final authStateProvider = StreamProvider<AppUser?>((ref) async* {
  // Emit the restored session first, then follow changes
  yield ref.watch(getCurrentUserProvider).call();
  yield* ref.watch(watchAuthStateProvider).call();
});
