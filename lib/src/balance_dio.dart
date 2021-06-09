import 'package:balance_http/src/balance_transformer.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';

class BalanceDio extends DioMixin implements Dio {
  BalanceDio() {
    transformer = BalanceTransformer();
  }
}
