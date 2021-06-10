import 'transformer.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';

class Ido extends DioMixin implements Dio {
  Ido([BaseOptions? baseOptions]) {
    options = baseOptions ?? BaseOptions();
    transformer = IdoTransformer();
  }
}
