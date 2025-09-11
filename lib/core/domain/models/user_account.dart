import 'package:equatable/equatable.dart';

import '../enums/user_type.dart';

class UserAccount extends Equatable {
  final String? id;
  final String? email;
  final UserType type;

  const UserAccount({
    this.id,
    this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'type': type.toString().split('.').last,
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] as String?,
      email: json['email'] as String?,
      type: (json['type'] == 'owner') ? UserType.owner : UserType.member,
    );
  }

  @override
  List<Object?> get props => [id, email, type];
}
