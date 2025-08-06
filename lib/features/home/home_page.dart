import 'package:expense_tracker/core/router/router_enum.dart';
import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authNotifier = ref.watch(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await authNotifier.logOut();
              context.go(RouterEnum.login.path);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
