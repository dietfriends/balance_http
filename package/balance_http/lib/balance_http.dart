/// Support for doing something awesome.
///
/// More dartdocs go here.
library balance_http;

/// A composable, [Future]-based library for making HTTP requests.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'src/client.dart';

export 'src/base_request.dart';
export 'src/client.dart';
export 'src/request.dart';

/// Sends an HTTP HEAD request with the given headers to the given URL.
///
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// This automatically initializes a new [BalanceClient] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [BalanceClient] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<http.Response> head(Uri url,
        {Map<String, String>? headers, Duration? timeout}) =>
    _withClient(
        (client) => client.head(url, headers: headers, timeout: timeout));

/// Sends an HTTP GET request with the given headers to the given URL.
///
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// This automatically initializes a new [BalanceClient] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [BalanceClient] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<http.Response> get(Uri url,
        {Map<String, String>? headers, Duration? timeout}) =>
    _withClient(
        (client) => client.get(url, headers: headers, timeout: timeout));

/// Sends an HTTP POST request with the given headers and body to the given URL.
///
/// [body] sets the body of the request. It can be a [String], a [List<int>] or
/// a [Map<String, String>]. If it's a String, it's encoded using [encoding] and
/// used as the body of the request. The content-type of the request will
/// default to "text/plain".
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
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<http.Response> post(Uri url,
        {Map<String, String>? headers,
        Object? body,
        Encoding? encoding,
        Duration? timeout}) =>
    _withClient((client) => client.post(url,
        headers: headers, body: body, encoding: encoding, timeout: timeout));

/// Sends an HTTP PUT request with the given headers and body to the given URL.
///
/// [body] sets the body of the request. It can be a [String], a [List<int>] or
/// a [Map<String, String>]. If it's a String, it's encoded using [encoding] and
/// used as the body of the request. The content-type of the request will
/// default to "text/plain".
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
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<http.Response> put(Uri url,
        {Map<String, String>? headers,
        Object? body,
        Encoding? encoding,
        Duration? timeout}) =>
    _withClient((client) => client.put(url,
        headers: headers, body: body, encoding: encoding, timeout: timeout));

/// Sends an HTTP PATCH request with the given headers and body to the given
/// URL.
///
/// [body] sets the body of the request. It can be a [String], a [List<int>] or
/// a [Map<String, String>]. If it's a String, it's encoded using [encoding] and
/// used as the body of the request. The content-type of the request will
/// default to "text/plain".
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
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// For more fine-grained control over the request, use [Request] or
/// [StreamedRequest] instead.
Future<http.Response> patch(Uri url,
        {Map<String, String>? headers,
        Object? body,
        Encoding? encoding,
        Duration? timeout}) =>
    _withClient((client) => client.patch(url,
        headers: headers, body: body, encoding: encoding, timeout: timeout));

/// Sends an HTTP DELETE request with the given headers to the given URL.
///
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// This automatically initializes a new [BalanceClient] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [BalanceClient] for all of those requests.
///
/// For more fine-grained control over the request, use [Request] instead.
Future<http.Response> delete(Uri url,
        {Map<String, String>? headers,
        Object? body,
        Encoding? encoding,
        Duration? timeout}) =>
    _withClient((client) => client.delete(url,
        headers: headers, body: body, encoding: encoding, timeout: timeout));

/// Sends an HTTP GET request with the given headers to the given URL and
/// returns a Future that completes to the body of the response as a [String].
///
/// The Future will emit a [ClientException] if the response doesn't have a
/// success status code.
///
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// This automatically initializes a new [BalanceClient] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [BalanceClient] for all of those requests.
///
/// For more fine-grained control over the request and response, use [Request]
/// instead.
Future<String> read(Uri url,
        {Map<String, String>? headers, Duration? timeout}) =>
    _withClient(
        (client) => client.read(url, headers: headers, timeout: timeout));

/// Sends an HTTP GET request with the given headers to the given URL and
/// returns a Future that completes to the body of the response as a list of
/// bytes.
///
/// The Future will emit a [ClientException] if the response doesn't have a
/// success status code.
///
/// If [timeout] is not null the request will be aborted if it takes longer than
/// the given duration to complete, and the returned future will complete as an
/// error with a [TimeoutException].
///
/// This automatically initializes a new [BalanceClient] and closes that client once
/// the request is complete. If you're planning on making multiple requests to
/// the same server, you should use a single [BalanceClient] for all of those requests.
///
/// For more fine-grained control over the request and response, use [Request]
/// instead.
Future<Uint8List> readBytes(Uri url,
        {Map<String, String>? headers, Duration? timeout}) =>
    _withClient(
        (client) => client.readBytes(url, headers: headers, timeout: timeout));

Future<T> _withClient<T>(Future<T> Function(BalanceClient) fn) async {
  var client = BalanceClient();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}
