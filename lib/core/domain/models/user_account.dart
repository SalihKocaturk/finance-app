import 'package:equatable/equatable.dart';

class UserAccount extends Equatable {
  final String? id;
  final String? email;

  const UserAccount({
    this.id,
    this.email,
  });

  @override
  List<Object?> get props => [id, email];
}
