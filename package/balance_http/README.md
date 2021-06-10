A composable, Future-based library for making HTTP requests.



## Usage

The easiest way to use this library is via the top-level functions. They allow you to make individual HTTP requests with minimal hassle:


```dart
import 'package:balance_http/balance_http.dart' as http;

var url = Uri.parse('https://example.com/whatsit/create');
var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');

print(await http.read(Uri.parse('https://example.com/foobar.txt')));
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
