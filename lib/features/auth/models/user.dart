import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime? birthDate;
  final String? imageUrl;

  User({
    String? id,
    required this.name,
    required this.email,
    this.birthDate,
    this.imageUrl,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'birthDate': birthDate?.toIso8601String(),
    'imageUrl': imageUrl,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String?,
    name: json['name'] as String,
    email: json['email'] as String,
    birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate'] as String) : null,
    imageUrl: json['imageUrl'] as String?,
  );

  @override
  String toString() => 'User{id: $id, name: $name, email: $email, birthDate: $birthDate, imageUrl: $imageUrl}';
}
