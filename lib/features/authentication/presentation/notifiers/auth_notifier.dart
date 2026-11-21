import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<void>(() async {
      await ref.read(signInProvider).call(email, password);
    });
  }

  Future<void> signUp(String displayName, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<void>(() async {
      await ref
          .read(signUpProvider)
          .call(displayName: displayName, email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<void>(() async {
      await ref.read(signOutProvider).call();
    });
  }
}

final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthNotifier, void>(AuthNotifier.new);
