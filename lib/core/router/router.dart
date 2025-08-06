import 'package:expense_tracker/core/router/router_enum.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/providers/user_provider.dart';
import '../../features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasUser = ref.watch(hasUserProvider);

  return GoRouter(
    initialLocation: RouterEnum.login.path,
    routes: [
      GoRoute(
        path: RouterEnum.login.path,
        name: RouterEnum.login.name,
        builder: (context, state) => const LoginPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? RouterEnum.home.path : null;
        },
      ),
      GoRoute(
        path: RouterEnum.register.path,
        name: RouterEnum.register.name,
        builder: (context, state) => const RegisterPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value != null ? RouterEnum.home.path : null;
        },
      ),
      GoRoute(
        path: RouterEnum.home.path,
        name: RouterEnum.home.name,
        builder: (context, state) => const HomePage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? null : RouterEnum.login.path;
        },
      ),
    ],
  );
});
