import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/providers/user_provider.dart';
import '../../features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasUser = ref.watch(hasUserProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value != null ? '/' : null;
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value != null ? '/' : null;
        },
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value != null ? null : '/login';
        },
      ),
    ],
  );
});
