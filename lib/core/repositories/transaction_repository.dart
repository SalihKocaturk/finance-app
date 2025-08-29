// class TransactionRepository {
//   final _transactionBox = HiveConstants.transactionBox;

//   List<Transaction>? getTransactions() {
//     return _transactionBox.values.toList();
//   }

//   Future<void> setTransaction(Transaction transaction) async {
//     await _transactionBox.put(transaction.id, transaction);
//   }

//   Future<void> removeTransactions() async {
//     await _transactionBox.clear();
//   }

//   Future<void> delete(String id) async {
//     await _transactionBox.delete(id);
//   }
// }
