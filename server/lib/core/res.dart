import 'dart:convert';

import 'package:server/entities/friend_request.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';

class Res extends Response {
  Res._(
    super.statusCode, {
    super.body,
    super.headers,
    super.context,
    super.encoding,
  });

  factory Res.toJson(
    int statusCode, {
    Object? body,
    Map<String, Object>? headers,
    Map<String, Object>? context,
    Encoding? encoding,
  }) {
    return Res._(
      statusCode,
      body: jsonEncode(body, toEncodable: _toEncodable),
      headers: {'Content-Type': 'application/json', ...?headers},
      context: context,
      encoding: encoding,
    );
  }

  static Object? _toEncodable(Object? object) {
    if (object is UserSchema) {
      return object.toMap()
        ..remove('password')
        ..remove('updated_at')
        ..remove('active');
    } else if (object is FriendRequestSchema) {
      return object.toMap();
    }

    return object;
  }
}
