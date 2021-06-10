// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'base_client.dart';
// ignore: uri_does_not_exist
import 'client_stub.dart'
    if (dart.library.html) 'browser_client.dart'
    if (dart.library.io) 'io_client.dart';

/// The interface for HTTP clients that take care of maintaining persistent
/// connections across multiple requests to the same server.
///
/// If you only need to send a single request, it's usually easier to use
/// [head], [get], [post], [put], [patch], or [delete] instead.
///
/// When creating an HTTP client class with additional functionality, you must
/// extend [BaseClient] rather than [BalanceClient]. In most cases, you can wrap
/// another instance of [BalanceClient] and add functionality on top of that. This
/// allows all classes implementing [BalanceClient] to be mutually composable.
abstract class BalanceClient extends http.Client {
  /// Creates a new platform appropriate client.
  ///
  /// Creates an `IOClient` if `dart:io` is available and a `BrowserClient` if
  /// `dart:html` is available, otherwise it will throw an unsupported error.
  factory BalanceClient() => createBalanceClient();

  /// Sends an HTTP HEAD request with the given headers to the given URL.
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> head(Uri url,
      {Map<String, String>? headers, Duration? timeout});

  /// Sends an HTTP GET request with the given headers to the given URL.
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> get(Uri url,
      {Map<String, String>? headers, Duration? timeout});

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      Duration? timeout});

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      Duration? timeout});

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  ///
  /// [body] sets the body of the request. It can be a [String], a [List<int>]
  /// or a [Map<String, String>]. If it's a String, it's encoded using
  /// [encoding] and used as the body of the request. The content-type of the
  /// request will default to "text/plain".
  ///
  /// If [body] is a List, it's used as a list of bytes for the body of the
  /// request.
  ///
  /// If [body] is a Map, it's encoded as form fields using [encoding]. The
  /// content-type of the request will be set to
  /// `"application/x-www-form-urlencoded"`; this cannot be overridden.
  ///
  /// [encoding] defaults to [utf8].
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      Duration? timeout});

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request, use [send] instead.
  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      Duration? timeout});

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a String.
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request and response, use [send] or
  /// [get] instead.
  @override
  Future<String> read(Uri url,
      {Map<String, String>? headers, Duration? timeout});

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a list of
  /// bytes.
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code.
  ///
  /// If [timeout] is not null the request will be aborted if it takes longer
  /// than the given duration to complete, and the returned future will complete
  /// as an error with a [TimeoutException].
  ///
  /// For more fine-grained control over the request and response, use [send] or
  /// [get] instead.
  @override
  Future<Uint8List> readBytes(Uri url,
      {Map<String, String>? headers, Duration? timeout});

  /// Sends an HTTP request and asynchronously returns the response.
  ///
  /// If [contentTimeout] is not null the request will be aborted if it takes
  /// longer than the given duration to receive the entire response. If the
  /// timeout occurs before any reply is received from the server the returned
  /// future will as an error with a [TimeoutException]. If the timout occurs
  /// after the reply has been started but before the entire body has been read
  /// the response stream will emit a [TimeoutException] and close.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request,
      {Duration? contentTimeout});

  /// Closes the client and cleans up any resources associated with it.
  ///
  /// It's important to close each client when it's done being used; failing to
  /// do so can cause the Dart process to hang.
  @override
  void close();
}
