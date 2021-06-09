import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'utils.dart';

class BalanceTransformer extends DefaultTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) {
    return super.transformRequest(options);
  }

  /// As an agreement, we return the [response] when the
  /// Options.responseType is [ResponseType.stream].
  @override
  Future transformResponse(
      RequestOptions options, ResponseBody response) async {
    if (options.responseType == ResponseType.stream) {
      return response;
    }
    var length = 0;
    var received = 0;
    var showDownloadProgress = options.onReceiveProgress != null;
    if (showDownloadProgress) {
      length = int.parse(
          response.headers[Headers.contentLengthHeader]?.first ?? '-1');
    }
    var completer = Completer();
    var stream =
        response.stream.transform<Uint8List>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);
        if (showDownloadProgress) {
          received += data.length;
          if (options.onReceiveProgress != null) {
            options.onReceiveProgress!(received, length);
          }
        }
      },
    ));
    // let's keep references to the data chunks and concatenate them later
    final chunks = <Uint8List>[];
    var finalSize = 0;
    StreamSubscription subscription = stream.listen(
      (chunk) {
        finalSize += chunk.length;
        chunks.add(chunk);
      },
      onError: (e, stackTrace) {
        completer.completeError(e, stackTrace);
      },
      onDone: () {
        completer.complete();
      },
      cancelOnError: true,
    );
    // ignore: unawaited_futures
    options.cancelToken?.whenCancel.then((_) {
      return subscription.cancel();
    });
    if (options.receiveTimeout > 0) {
      try {
        await completer.future
            .timeout(Duration(milliseconds: options.receiveTimeout));
      } on TimeoutException {
        await subscription.cancel();
        throw DioError(
          requestOptions: options,
          error: 'Receiving data timeout[${options.receiveTimeout}ms]',
          type: DioErrorType.receiveTimeout,
        );
      }
    } else {
      await completer.future;
    }
    // we create a final Uint8List and copy all chunks into it
    final responseBytes = Uint8List(finalSize);
    var chunkOffset = 0;
    for (var chunk in chunks) {
      responseBytes.setAll(chunkOffset, chunk);
      chunkOffset += chunk.length;
    }

    if (options.responseType == ResponseType.bytes) return responseBytes;

    String? responseBody;
    if (options.responseDecoder != null) {
      responseBody = options.responseDecoder!(
        responseBytes,
        options,
        response..stream = Stream.empty(),
      );
    } else {
      responseBody = utf8.decode(responseBytes, allowMalformed: true);
    }
    if (responseBody.isNotEmpty &&
        options.responseType == ResponseType.json &&
        isJsonMime(response.headers[Headers.contentTypeHeader]?.first)) {
      final callback = jsonDecodeCallback;
      if (callback != null) {
        return callback(responseBody);
      } else {
        return json.decode(responseBody);
      }
    }
    return responseBody;
  }
}
