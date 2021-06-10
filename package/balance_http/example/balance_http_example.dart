import 'package:balance_http/balance_http.dart' as http;
import 'dart:io';

void main() async {
  var url = Uri.parse('https://example.com/whatsit/create');
  var response =
      await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  print(await http.read(Uri.parse('https://example.com/foobar.txt')));
}
