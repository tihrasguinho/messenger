import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'routes/all.dart';
import 'routes/by_uid.dart';

class UsersResource {
  static Handler routes() {
    final router = Router();

    router.get('/', all);

    router.get('/<uid>', byUid);

    return router;
  }
}
