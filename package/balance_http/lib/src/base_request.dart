// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:http/src/base_request.dart';
import 'package:http/src/byte_stream.dart';
import 'package:http/src/streamed_response.dart';
import 'package:http/src/utils.dart';

import 'client.dart';

/// The base class for HTTP requests.
///
/// Subclasses of [BalanceRequest] can be constructed manually and passed to
/// [BalanceClient.send], which allows the user to provide fine-grained control
/// over the request properties. However, usually it's easier to use convenience
/// methods like [get] or [BalanceClient.get].
abstract class BalanceRequest extends BaseRequest {
  BalanceRequest(String method, Uri url) : super(method, url);

  /// Sends this request.
  ///
  /// This automatically initializes a new [BalanceClient] and closes that client once
  /// the request is complete. If you're planning on making multiple requests to
  /// the same server, you should use a single [BalanceClient] for all of those
  /// requests.
  ///
  /// If [contentTimeout] is not null the request will be aborted if it takes
  /// longer than the given duration to receive the entire response. If the
  /// timeout occurs before any reply is received from the server the returned
  /// future will as an error with a [TimeoutException]. If the timout occurs
  /// after the reply has been started but before the entire body has been read
  /// the response stream will emit a [TimeoutException] and close.
  @override
  Future<StreamedResponse> send({Duration? contentTimeout}) async {
    var client = BalanceClient();

    try {
      var response = await client.send(this, contentTimeout: contentTimeout);
      var stream = onDone(response.stream, client.close);
      return StreamedResponse(ByteStream(stream), response.statusCode,
          contentLength: response.contentLength,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase);
    } catch (_) {
      client.close();
      rethrow;
    }
  }
}
