import 'package:riverpod/riverpod.dart';

final codeValueProvider = StateProvider.autoDispose<String>((ref) => '');
final loginEmailProvider = StateProvider<String>((ref) => '');
final loginPasswordProvider = StateProvider<String>((ref) => '');
final registernameProvider = StateProvider<String>((ref) => '');
final registerEmailProvider = StateProvider<String>((ref) => '');
final registerPasswordProvider = StateProvider<String>((ref) => '');
final registerPassword2Provider = StateProvider<String>((ref) => '');
final passwordVisibleProvider = StateProvider<bool>((ref) => true);
final birthDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
//isimlendirmeler duzeltilecek ve register icin ayrı ayrı yapılacak provider
//TODO:: loginpasswordprovider olusturulacak, email provider da iki defa olcak
