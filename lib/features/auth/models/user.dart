import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({String? id, required this.name, required this.email}) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String?,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  @override
  String toString() => 'User{id: $id, name: $name, email: $email}';
}
