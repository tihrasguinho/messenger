import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/friend.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> removeFriendship(Request request, String friendshipUid) async {
  try {
    final sqleto = SQLeto.instance;

    final friendship = await sqleto.findByPK<FriendSchema>(friendshipUid);

    final where = Where('user_uid', Operator.EQUALS, friendship.friendUid)..and(Where('friend_uid', Operator.EQUALS, friendship.userUid));

    final friendships = await sqleto.select<FriendSchema>(where);

    for (var fs in friendships) {
      await fs.delete();
    }

    await friendship.delete();

    return Res.toJson(200, body: {'message': 'Friendship successfuly removed!'});
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
