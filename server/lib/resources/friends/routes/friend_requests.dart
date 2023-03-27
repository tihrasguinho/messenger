import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/friend_request.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> friendRequests(Request request) async {
  try {
    final sqleto = SQLeto.instance;

    final uid = request.context['uid'] as String;

    final friendRequests = await sqleto.select<FriendRequestSchema>(Where('friend_uid', Operator.EQUALS, uid));

    final requestsMapped = <Map<String, dynamic>>[];

    for (var friendRequest in friendRequests) {
      final friend = await sqleto.findByPK<UserSchema>(friendRequest.userUid);

      requestsMapped.add({
        'request_uid': friendRequest.uid,
        'created_at': friendRequest.createdAt.millisecondsSinceEpoch,
        'friend': friend,
      });
    }

    return Res.toJson(
      200,
      body: {
        'message': 'Listing all friend requests!',
        'requests': requestsMapped,
      },
    );
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
