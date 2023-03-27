import 'dart:async';

import 'package:server/core/res.dart';
import 'package:server/entities/friend.dart';
import 'package:server/entities/user.dart';
import 'package:shelf/shelf.dart';
import 'package:sqleto/sqleto.dart';

FutureOr<Res> friends(Request request) async {
  try {
    final sqleto = SQLeto.instance;

    final uid = request.context['uid'] as String;

    final friends = await sqleto.select<FriendSchema>(Where('user_uid', Operator.EQUALS, uid));

    final friendsMapped = <Map<String, dynamic>>[];

    for (var friend in friends) {
      final friendSchema = await sqleto.findByPK<UserSchema>(friend.friendUid);

      friendsMapped.add({
        'friendship_uid': friend.uid,
        'created_at': friend.createdAt.millisecondsSinceEpoch,
        'friend': friendSchema,
      });
    }

    return Res.toJson(
      200,
      body: {
        'message': 'Listing all friends!',
        'friends': friendsMapped,
      },
    );
  } on SQLetoException catch (e) {
    return Res.toJson(400, body: {'error': e.error});
  } on Exception catch (e) {
    return Res.toJson(400, body: {'error': e.toString()});
  }
}
