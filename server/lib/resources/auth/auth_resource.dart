import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'routes/sign_in.dart';
import 'routes/sign_up.dart';

class AuthResource {
  static Handler routes() {
    final router = Router();

    router.post('/signup', signUp);

    router.post('/signin', signIn);

    return router;
  }
}
