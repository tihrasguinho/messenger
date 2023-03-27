import 'dart:async';
import 'dart:convert';

import 'package:server/core/res.dart';
import 'package:server/core/services/jwt_service.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> signUp(Request request) async {
  try {
    final sqleto = SQLeto.instance;

    final params = Map<String, dynamic>.from(jsonDecode(await request.readAsString()));

    if (!_validade(params)) {
      return Res.toJson(
        400,
        body: {
          'error': 'Some params is missing or malformed!',
        },
      );
    }

    final user = await sqleto.insert<UserSchema>(
      () => UserSchema.create(
        name: params['name'],
        username: params['username'],
        email: params['email'],
        password: params['password'],
        image: '',
      ),
    );

    return Res.toJson(
      200,
      body: {
        'user': user,
        'credentials': {
          'access_token': JwtService.sign(user.uid),
          'refresh_token': JwtService.sign(user.uid, refresh: true),
          'expires_in': 3600,
        }
      },
    );
  } on SQLetoException catch (e) {
    if (e is DatabaseConflictException) return Res.toJson(409, body: {'error': e.error});

    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}

bool _validade(Map<String, dynamic> params) {
  return params.containsKey('name') &&
      params['name'] is String &&
      params.containsKey('username') &&
      params['username'] is String &&
      params.containsKey('email') &&
      params['email'] is String &&
      params.containsKey('password') &&
      params['password'] is String;
}
