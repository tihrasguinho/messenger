import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/friend_request.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> sendFriendRequest(Request request, String uid) async {
  try {
    final loggedUid = request.context['uid'] as String;

    final sqleto = SQLeto.instance;

    Where where = Where('user_uid', Operator.EQUALS, loggedUid)..and(Where('friend_uid', Operator.EQUALS, uid));

    List<FriendRequestSchema> requests = await sqleto.select<FriendRequestSchema>(where);

    if (requests.isNotEmpty) {
      return Res.toJson(400, body: {'error': 'Friend request already exists!'});
    }

    where = Where('user_uid', Operator.EQUALS, uid)..and(Where('friend_uid', Operator.EQUALS, loggedUid));

    requests = await sqleto.select<FriendRequestSchema>(where);

    if (requests.isNotEmpty) {
      return Res.toJson(400, body: {'error': 'You already have a friend request from this user waiting!'});
    }

    await sqleto.insert<FriendRequestSchema>(() => FriendRequestSchema.create(userUid: loggedUid, friendUid: uid));

    return Res.toJson(200, body: {'message': 'Friend request sended!'});
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
