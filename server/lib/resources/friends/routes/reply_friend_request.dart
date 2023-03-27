import 'dart:async';
import 'dart:convert';

import 'package:server/core/res.dart';
import 'package:server/entities/friend.dart';
import 'package:server/entities/friend_request.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> replyFriendRequest(Request request, String requestUid) async {
  try {
    final sqleto = SQLeto.instance;

    final params = Map<String, dynamic>.from(jsonDecode(await request.readAsString()));

    if (!_validate(params)) {
      return Res.toJson(400, body: {'error': 'Some params is missing or malformed!'});
    }

    final friendRequest = await sqleto.findByPK<FriendRequestSchema>(requestUid);

    if (params['acept']) {
      await sqleto.insert<FriendSchema>(() => FriendSchema.create(userUid: friendRequest.userUid, friendUid: friendRequest.friendUid));

      await sqleto.insert<FriendSchema>(() => FriendSchema.create(userUid: friendRequest.friendUid, friendUid: friendRequest.userUid));

      await friendRequest.delete();

      return Res.toJson(200, body: {'message': 'Friendship successfully acepted!'});
    } else {
      await friendRequest.delete();

      return Res.toJson(200, body: {'message': 'Friendship successfully rejected!'});
    }
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}

bool _validate(Map<String, dynamic> params) {
  return params.containsKey('acept') && params['acept'] is bool;
}
