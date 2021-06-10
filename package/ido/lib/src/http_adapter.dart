import 'dart:typed_data';

import 'package:balance_http/balance_http.dart';
import 'package:buffer/buffer.dart';
import 'package:dio/dio.dart';

class HttpAdapter implements HttpClientAdapter {
  late final BalanceClient _defaultClient = BalanceClient();

  @override
  void close({bool force = false}) {
    _defaultClient.close();
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future? cancelFuture) async {
    final request = Request(options.method, options.uri);

    options.headers.forEach((k, v) => request.headers[k] = v);
    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;

    if (requestStream != null) {
      request.bodyBytes = await _readFully(requestStream);
    }

    Duration? connectTimeout;
    if (options.connectTimeout > 0) {
      connectTimeout = Duration(milliseconds: options.connectTimeout);
    }

    final response =
        await _defaultClient.send(request, contentTimeout: connectTimeout);

    return ResponseBody(
      response.stream.cast(),
      response.statusCode,
      headers: response.headers.map((key, value) => MapEntry(key, [value])),
      isRedirect: response.isRedirect,
      statusMessage: response.reasonPhrase,
    );
  }

  Future<Uint8List> _readFully(Stream<List<int>> stream) async {
    var buffer = BytesBuffer();
    await for (var b in stream) {
      buffer.add(b);
    }
    return buffer.toBytes();
  }
}
