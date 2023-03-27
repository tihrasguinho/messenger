import 'package:server/resources/users/users_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'resources/auth/auth_resource.dart';
import 'resources/friends/friends_resource.dart';

class ServerModule {
  static Handler resources() {
    final router = Router();

    router.mount('/auth', AuthResource.routes());

    router.mount('/users', UsersResource.routes());

    router.mount('/friends', FriendsResource.routes());

    return router;
  }
}
