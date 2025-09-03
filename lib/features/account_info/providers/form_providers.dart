import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider = StateProvider<XFile?>((ref) => null);

final editNameProvider = StateProvider<String>((ref) => '');

final editEmailProvider = StateProvider<String>((ref) => '');
final editPasswordProvider = StateProvider<String>((ref) => '');

final editBirthDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
