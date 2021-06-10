@TestOn('vm')
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ido/src/http_ido.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  setUp(startServer);

  tearDown(stopServer);

  group('#test requests', () {
    late HttpIdo dio;
    setUp(() {
      dio = HttpIdo();
      dio.options
        ..baseUrl = serverUrl.toString()
        ..connectTimeout = 1000
        ..receiveTimeout = 5000
        ..headers = {'User-Agent': 'dartisan'};
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        logPrint: (log) => {
          // ignore log
        },
      ));
    });
    test('#test restful APIs', () async {
      Response response;

      // test get
      response = await dio.get(
        '/test',
        queryParameters: {'id': '12', 'name': 'wendu'},
      );
      expect(response.statusCode, 200);
      expect(response.isRedirect, false);
      expect(response.data['query'], equals('id=12&name=wendu'));
      expect(response.headers.value('single'), equals('value'));

      const map = {'content': 'I am playload'};

      // test post
      response = await dio.post('/test', data: map);
      expect(response.data['method'], 'POST');
      expect(response.data['body'], jsonEncode(map));

      // test put
      response = await dio.put('/test', data: map);
      expect(response.data['method'], 'PUT');
      expect(response.data['body'], jsonEncode(map));

      // test patch
      response = await dio.patch('/test', data: map);
      expect(response.data['method'], 'PATCH');
      expect(response.data['body'], jsonEncode(map));

      // test head
      response = await dio.delete('/test', data: map);
      expect(response.data['method'], 'DELETE');
      expect(response.data['path'], '/test');

      // error test
      expect(dio.get('/error').catchError((e) => throw e.response.statusCode),
          throwsA(equals(400)));

      // redirect test
      response = await dio.get(
        '/redirect',
        //options: Options(followRedirects: false),
        onReceiveProgress: (received, total) {
          // ignore progress
        },
      );
      assert(response.isRedirect == false);
    });

    test('#test request with URI', () async {
      Response response;

      // test get
      response = await dio.getUri(
        Uri(path: '/test', queryParameters: {'id': '12', 'name': 'wendu'}),
      );
      expect(response.statusCode, 200);
      expect(response.isRedirect, false);
      expect(response.data['query'], equals('id=12&name=wendu'));
      expect(response.headers.value('single'), equals('value'));

      const map = {'content': 'I am playload'};

      // test post
      response = await dio.postUri(Uri(path: '/test'), data: map);
      expect(response.data['method'], 'POST');
      expect(response.data['body'], jsonEncode(map));

      // test put
      response = await dio.putUri(Uri(path: '/test'), data: map);
      expect(response.data['method'], 'PUT');
      expect(response.data['body'], jsonEncode(map));

      // test patch
      response = await dio.patchUri(Uri(path: '/test'), data: map);
      expect(response.data['method'], 'PATCH');
      expect(response.data['body'], jsonEncode(map));

      // test head
      response = await dio.deleteUri(Uri(path: '/test'), data: map);
      expect(response.data['method'], 'DELETE');
      expect(response.data['path'], '/test');
    });

    test('#test redirect', () async {
      Response response;
      response =
          await dio.get('/redirect', options: Options(followRedirects: true));
      expect(response.isRedirect, isFalse);
      expect(response.statusCode, 200);
      //assert(response.method == 'GET');
      //assert(response.location.path == '/');
      //expect(response.headers, 200);
    });

    test('#test generic parameters', () async {
      Response response;

      // default is "Map"
      response = await dio.get('/test');
      expect(response.data, isA<Map>());

      // get response as `string`
      response = await dio.get<String>('/test');
      expect(response.data, isA<String>());

      // get response as `Map`
      response = await dio.get<Map>('/test');
      expect(response.data, isA<Map>());

      // get response as `List`
      response = await dio.get<List>('/list');
      expect(response.data, isA<List>());
      expect(response.data[0], 1);
    });
  });
}
