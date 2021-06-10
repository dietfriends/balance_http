// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'base_client.dart';

/// Create an [IOClient].
///
/// Used from conditional imports, matches the definition in `client_stub.dart`.
BaseBalanceClient createBalanceClient() => IOBalanceClient();

/// A `dart:io`-based HTTP client.
class IOBalanceClient extends BaseBalanceClient {
  /// The underlying `dart:io` HTTP client.
  HttpClient? _inner;

  IOBalanceClient([HttpClient? inner]) : _inner = inner ?? HttpClient();

  /// Sends an HTTP request and asynchronously returns the response.
  @override
  Future<IOStreamedResponse> send(BaseRequest request,
      {Duration? contentTimeout}) {
    final completer = Completer<IOStreamedResponse>();
    _send(request, contentTimeout, completer);
    return completer.future;
  }

  Future<void> _send(BaseRequest request, Duration? contentTimeout,
      Completer<IOStreamedResponse> completer) async {
    var stream = request.finalize();

    Timer? timer;
    void Function() onTimeout;
    if (contentTimeout != null) {
      onTimeout = () {
        if (!completer.isCompleted) {
          completer.completeError(
              TimeoutException('Request aborted', contentTimeout));
        }
      };
      timer = Timer(contentTimeout, () {
        onTimeout();
      });
    }
    try {
      var ioRequest = (await _inner!.openUrl(request.method, request.url))
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..contentLength = (request.contentLength ?? -1)
        ..persistentConnection = request.persistentConnection;
      if (completer.isCompleted) return;
      request.headers.forEach((name, value) {
        ioRequest.headers.set(name, value);
      });

      if (contentTimeout != null) {
        onTimeout = () {
          ioRequest.abort();
          if (!completer.isCompleted) {
            completer.completeError(
                TimeoutException('Request aborted', contentTimeout));
          }
        };
      }

      var response = await stream.pipe(ioRequest) as HttpClientResponse;
      if (completer.isCompleted) return;

      var headers = <String, String>{};
      response.headers.forEach((key, values) {
        headers[key] = values.join(',');
      });
      var wasTimedOut = false;
      if (contentTimeout != null) {
        onTimeout = () {
          wasTimedOut = true;
          response.detachSocket().then((socket) => socket.destroy());
        };
      }
      var responseStream = response.handleError((error) {
        final httpException = error as HttpException;
        throw ClientException(httpException.message, httpException.uri);
      }, test: (error) => error is HttpException).transform<List<int>>(
          StreamTransformer.fromHandlers(handleDone: (sink) {
        timer?.cancel();
        if (wasTimedOut) {
          sink.addError(TimeoutException('Request aborted', contentTimeout));
        }
        sink.close();
      }));

      if (!completer.isCompleted) {
        completer.complete(IOStreamedResponse(
            responseStream, response.statusCode,
            contentLength:
                response.contentLength == -1 ? null : response.contentLength,
            request: request,
            headers: headers,
            isRedirect: response.isRedirect,
            persistentConnection: response.persistentConnection,
            reasonPhrase: response.reasonPhrase,
            inner: response));
      }
    } on HttpException catch (error) {
      if (completer.isCompleted) return;
      completer.completeError(ClientException(error.message, error.uri));
    } catch (error, stackTrace) {
      if (completer.isCompleted) return;
      completer.completeError(error, stackTrace);
    }
  }

  /// Closes the client.
  ///
  /// Terminates all active connections. If a client remains unclosed, the Dart
  /// process may not terminate.
  @override
  void close() {
    if (_inner != null) {
      _inner!.close(force: true);
      _inner = null;
    }
  }
}
