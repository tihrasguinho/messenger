import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'routes/friend_requests.dart';
import 'routes/friends.dart';
import 'routes/remove_friendship.dart';
import 'routes/reply_friend_request.dart';
import 'routes/send_friend_request.dart';

class FriendsResource {
  static Handler routes() {
    final router = Router();

    router.get('/', friends);

    router.post('/remove-friendship/<friendshipUid>', removeFriendship);

    router.get('/friend-requests', friendRequests);

    router.post('/send-friend-request/<uid>', sendFriendRequest);

    router.post('/reply-friend-request/<requestUid>', replyFriendRequest);

    return router;
  }
}
