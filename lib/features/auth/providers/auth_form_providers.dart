import 'package:riverpod/riverpod.dart';

final nameProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => 'kocaturksalih8@gmail.com');
final passwordProvider = StateProvider<String>((ref) => 'Salihbaba');
final password2Provider = StateProvider<String>((ref) => '');
//TODO:: loginpasswordprovider olusturulacak, email provider da iki defa olcak
