import 'package:http_parser/http_parser.dart';

bool isJsonMime(String? contentType) {
  if (contentType == null) {
    return false;
  }
  final mediaType = MediaType.parse(contentType);
  return mediaType.type == 'application' &&
      mediaType.subtype.contains(RegExp(r'\+?json'));
}
