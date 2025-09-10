import 'package:riverpod/riverpod.dart';

import '../../../core/services/firebase_services.dart';

final hasAccountProvider = FutureProvider<bool>((ref) async {
  final hasAccount = await FirebaseService().getAccountSession();
  return hasAccount != null;
});
