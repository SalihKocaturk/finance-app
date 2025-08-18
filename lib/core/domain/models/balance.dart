import 'package:equatable/equatable.dart';

import '../../services/services.dart';

class Balance extends Equatable {
  final String id;
  final double income;
  final double expense;

  Balance({
    String? id,
    required this.income,
    required this.expense,
  }) : id = id ?? uuid;

  double get balance => income - expense;

  @override
  List<Object?> get props => [id, income, expense];
}
//#41495E