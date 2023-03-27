import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> all(Request request) async {
  try {
    final sqleto = SQLeto.instance;

    final queryParams = request.url.queryParameters;

    final uid = request.context['uid'] as String;

    Where? where;

    if (queryParams.isNotEmpty) {
      if (queryParams.keys.elementAt(0) == 'name' || queryParams.keys.elementAt(0) == 'username') {
        where = Where(queryParams.keys.elementAt(0), Operator.EQUALS, queryParams.values.elementAt(0));
        where.or(Where(queryParams.keys.elementAt(0), Operator.I_LIKE, '${queryParams.values.elementAt(0)}%'));
      } else {
        where = Where(queryParams.keys.elementAt(0), Operator.EQUALS, queryParams.values.elementAt(0));
      }

      for (var i = 1; i < queryParams.length; i++) {
        if (queryParams.keys.elementAt(i) == 'name' || queryParams.keys.elementAt(i) == 'username') {
          where.or(Where(queryParams.keys.elementAt(i), Operator.EQUALS, queryParams.values.elementAt(i)));
          where.or(Where(queryParams.keys.elementAt(i), Operator.I_LIKE, '${queryParams.values.elementAt(i)}%'));
        } else {
          where.or(Where(queryParams.keys.elementAt(i), Operator.EQUALS, queryParams.values.elementAt(i)));
        }
      }
    }

    if (where != null) {
      where.and(Where('active', Operator.EQUALS, true));
      where.and(Where('uid', Operator.NOT_EQUAL, uid));
    } else {
      where = Where('active', Operator.EQUALS, true)..and(Where('uid', Operator.NOT_EQUAL, uid));
    }

    final users = await sqleto.select<UserSchema>(where);

    return Res.toJson(
      200,
      body: {
        'users': users,
      },
    );
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
