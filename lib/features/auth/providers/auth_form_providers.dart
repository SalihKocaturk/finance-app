import 'package:riverpod/riverpod.dart';

final loginEmailProvider = StateProvider<String>((ref) => 'kocaturksalih8@gmail.com');
final loginPasswordProvider = StateProvider<String>((ref) => 'Salihbaba');
final registernameProvider = StateProvider<String>((ref) => '');
final registerEmailProvider = StateProvider<String>((ref) => 'kocaturksalih8@gmail.com');
final registerPasswordProvider = StateProvider<String>((ref) => '');
final registerPassword2Provider = StateProvider<String>((ref) => '');
final passwordVisibleProvider = StateProvider<bool>((ref) => true);

//isimlendirmeler duzeltilecek ve register icin ayrı ayrı yapılacak provider
//TODO:: loginpasswordprovider olusturulacak, email provider da iki defa olcak
