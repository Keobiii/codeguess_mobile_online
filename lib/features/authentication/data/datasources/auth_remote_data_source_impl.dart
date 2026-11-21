import 'package:codeguess/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:codeguess/features/authentication/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Sign in failed');
    }

    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<UserModel> signUp(
    String displayName,
    String email,
    String password,
  ) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Sign up failed');
    }

    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> signOut() => client.auth.signOut();

  @override
  UserModel? getCurrentUser() {
    final user = client.auth.currentUser;
    return user == null ? null : UserModel.fromSupabaseUser(user);
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return client.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      return user == null ? null : UserModel.fromSupabaseUser(user);
    });
  }
}
