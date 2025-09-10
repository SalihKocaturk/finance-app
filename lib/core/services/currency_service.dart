import 'package:dio/dio.dart';
import 'package:expense_tracker/core/constants/api_constant.dart';

import '../constants/toast.dart';
import '../domain/enums/alert_type.dart';

class CurrencyService {
  final Dio _dio = Dio();

  Future<double> getUsdRate() async {
    try {
      final res = await _dio.get(ApiConstant.url);

      if (res.statusCode == 200) {
        final rate = (res.data?['data']?['USD'] as num?)?.toDouble();
        if (rate == null) {
          final message = 'USD değeri yok: ${res.data}';
          showToast(
            message,
            AlertType.fail,
          );
          throw Exception(message);
        }
        return rate;
      } else {
        showToast(
          "hata",
          AlertType.fail,
        );
      }

      final message = 'API error: ${res.statusCode} ${res.data}';
      showToast(
        message,
        AlertType.fail,
      );
      throw Exception(
        message,
      );
    } on DioException catch (e) {
      final message = 'İnternet veya API hatası: ${e.message}';
      showToast(
        message,
        AlertType.fail,
      );
      rethrow;
    } catch (e) {
      final message = 'Bilinmeyen hata: $e';
      showToast(
        message,
        AlertType.fail,
      );
      rethrow;
    }
  }

  Future<double> getEurRate() async {
    try {
      final res = await _dio.get(ApiConstant.url);

      if (res.statusCode == 200) {
        final rate = (res.data?['data']?['EUR'] as num?)?.toDouble();
        if (rate == null) {
          final message = 'EUR değeri yok: ${res.data}';
          showToast(
            message,
            AlertType.fail,
          );
          throw Exception(message);
        }
        return rate;
      } else {
        showToast(
          "hata",
          AlertType.fail,
        );
      }

      final message = 'API error: ${res.statusCode} ${res.data}';
      showToast(
        message,
        AlertType.fail,
      );
      throw Exception(message);
    } on DioException catch (e) {
      final message = 'İnternet veya API hatası: ${e.message}';
      showToast(
        message,
        AlertType.fail,
      );
      rethrow;
    } catch (e) {
      final message = 'Bilinmeyen hata: $e';
      showToast(
        message,
        AlertType.fail,
      );
      rethrow;
    }
  }
}
