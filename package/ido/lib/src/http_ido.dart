import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:ido/src/http_adapter.dart';

import 'transformer.dart';

class HttpIdo extends DioForNative implements Dio {
  HttpIdo([BaseOptions? baseOptions]) {
    options = baseOptions ?? BaseOptions();
    transformer = IdoTransformer();
    httpClientAdapter = HttpAdapter();
  }
}
