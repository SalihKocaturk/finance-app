import 'package:expense_tracker/core/router/router_enum.dart';
import 'package:expense_tracker/features/auth/pages/login_page.dart';
import 'package:expense_tracker/features/base/base_page.dart';
import 'package:expense_tracker/features/profile/pages/profile_page.dart';
import 'package:expense_tracker/features/transaction/pages/transaction_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../../features/auth/pages/register_page.dart';
import '../../features/auth/providers/user_provider.dart';
import '../../features/home/pages/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasUser = ref.watch(hasUserProvider);

  return GoRouter(
    initialLocation: RouterEnum.login.path,
    routes: [
      GoRoute(
        path: RouterEnum.base.path,
        name: RouterEnum.base.name,
        builder: (context, state) => const BasePage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? null : RouterEnum.login.path;
        },
      ),
      GoRoute(
        path: RouterEnum.login.path,
        name: RouterEnum.login.name,
        builder: (context, state) => const LoginPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? RouterEnum.base.path : null;
        },
      ),
      GoRoute(
        path: RouterEnum.register.path,
        name: RouterEnum.register.name,
        builder: (context, state) => const RegisterPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? RouterEnum.base.path : null;
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
      GoRoute(
        path: RouterEnum.profile.path,
        name: RouterEnum.profile.name,
        builder: (context, state) => const ProfilePage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? null : RouterEnum.login.path;
        },
      ),
      GoRoute(
        path: RouterEnum.transaction.path,
        name: RouterEnum.transaction.name,
        builder: (context, state) => const TransactionPage(),
        redirect: (context, state) {
          if (hasUser.isLoading) return null;
          return hasUser.value == true ? null : RouterEnum.login.path;
        },
      ),
    ],
  );
});
