import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> byUid(Request request, String uid) async {
  try {
    final sqleto = SQLeto.instance;

    final user = await sqleto.findByPK<UserSchema>(uid);

    if (!user.active) {
      return Res.toJson(404, body: {'error': 'User not found!'});
    }

    return Res.toJson(
      200,
      body: {
        'message': 'Founded user from UID: $uid!',
        'user': user,
      },
    );
  } on SQLetoException catch (e) {
    if (e is NotFoundException) return Res.toJson(404, body: {'error': e.error});

    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
