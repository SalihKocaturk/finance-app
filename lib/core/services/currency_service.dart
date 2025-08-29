import 'package:dio/dio.dart';
import 'package:expense_tracker/core/constants/api_constant.dart';

import '../constants/toast.dart';

class CurrencyService {
  final Dio _dio = Dio();

  Future<double> getUsdRate() async {
    try {
      final res = await _dio.get(ApiConstant.url);

      if (res.statusCode == 200) {
        final rate = (res.data?['data']?['USD'] as num?)?.toDouble();
        if (rate == null) {
          final msg = 'USD değeri yok: ${res.data}';
          showToast(msg);
          throw Exception(msg);
        }
        print("succes: $rate");
        return rate;
      } else {
        showToast("hata");
      }

      final msg = 'API error: ${res.statusCode} ${res.data}';
      showToast(msg);
      throw Exception(msg);
    } on DioException catch (e) {
      final msg = 'İnternet veya API hatası: ${e.message}';
      showToast(msg);
      rethrow;
    } catch (e) {
      final msg = 'Bilinmeyen hata: $e';
      showToast(msg);
      rethrow;
    }
  }

  Future<double> getEurRate() async {
    try {
      final res = await _dio.get(ApiConstant.url);

      if (res.statusCode == 200) {
        final rate = (res.data?['data']?['EUR'] as num?)?.toDouble();
        if (rate == null) {
          final msg = 'EUR değeri yok: ${res.data}';
          showToast(msg);
          throw Exception(msg);
        }
        print("succes: $rate");
        return rate;
      } else {
        showToast("hata");
      }

      final msg = 'API error: ${res.statusCode} ${res.data}';
      showToast(msg);
      throw Exception(msg);
    } on DioException catch (e) {
      final msg = 'İnternet veya API hatası: ${e.message}';
      showToast(msg);
      rethrow;
    } catch (e) {
      final msg = 'Bilinmeyen hata: $e';
      showToast(msg);
      rethrow;
    }
  }
}
