import 'package:codeguess/features/authentication/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: (user.userMetadata?['display_name'] as String?) ?? '',
    );
  }
}
