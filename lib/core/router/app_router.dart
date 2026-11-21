import 'package:codeguess/features/authentication/presentation/pages/login_page.dart';
import 'package:codeguess/features/authentication/presentation/pages/register_page.dart';
import 'package:codeguess/features/codeguess/presentation/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/codeguess/presentation/pages/history_page.dart';
import '../../features/codeguess/presentation/pages/home_page.dart';

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(authStateProvider, (previous, next) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      // While the stream hasn't emitted yet, ask Supabase directly
      final user = authState.hasValue
          ? authState.value
          : ref.read(getCurrentUserProvider).call();

      final isLoggedIn = user != null;
      final location = state.matchedLocation;
      final onAuthPage = location == '/login' || location == '/register';

      if (!isLoggedIn && !onAuthPage) return '/login';
      if (isLoggedIn && onAuthPage) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/game/:language',
        builder: (context, state) {
          final langauge = state.pathParameters['language']!;

          return GamePage(langauge: langauge);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
    ],
  );
});
