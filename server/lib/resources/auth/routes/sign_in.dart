import 'dart:async';
import 'dart:convert';

import 'package:server/core/res.dart';
import 'package:server/core/services/jwt_service.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> signIn(Request request) async {
  try {
    final sqleto = SQLeto.instance;

    final params = Map<String, dynamic>.from(jsonDecode(await request.readAsString()));

    if (!_validate(params)) {
      return Res.toJson(
        400,
        body: {
          'error': 'Some params is missing!',
        },
      );
    }

    final users = await sqleto.select<UserSchema>(Where('email', Operator.EQUALS, params['email']));

    if (users.isEmpty) {
      return Res.toJson(
        404,
        body: {
          'error': 'User not found!',
        },
      );
    }

    final user = users.first;

    if (!SQLetoUtils.passwordMatches(params['password'], user.password)) {
      return Res.toJson(
        401,
        body: {
          'error': 'Wrong password!',
        },
      );
    }

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
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}

bool _validate(Map<String, dynamic> params) {
  return params.containsKey('email') && params['email'] is String && params.containsKey('password') && params['password'] is String;
}
