import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app.dart';
import 'core/constants/hive_constants.dart';
import 'features/auth/models/user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(HiveConstants.userBoxName);

  runApp(
    const ProviderScope(
      child: OverlaySupport.global(
        child: App(),
      ),
    ),
  );
}
