import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  User({
    String? id,
    required this.name,
    required this.email,
  }) : id = id ?? const Uuid().v4();

  @override
  String toString() => 'User{id: $id, name: $name, email: $email}';
}
