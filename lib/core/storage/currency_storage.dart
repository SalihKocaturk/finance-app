import 'package:expense_tracker/core/domain/enums/transaction_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyStorage {
  static const _key = 'currency_type';
  Future<CurrencyType?> readCurrency() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString(_key);
    if (code == null || code.isEmpty) return null;
    if (code == "tl") {
      return CurrencyType.tl;
    } else if (code == "usd") {
      return CurrencyType.usd;
    } else {
      return CurrencyType.eur;
    }
  }

  Future<void> setCurrency(CurrencyType type) async {
    final sp = await SharedPreferences.getInstance();
    if (type == CurrencyType.tl) {
      await sp.setString(_key, "tl");
    } else if (type == CurrencyType.usd) {
      await sp.setString(_key, "usd");
    } else {
      await sp.setString(_key, "eur");
    }
  }
}
