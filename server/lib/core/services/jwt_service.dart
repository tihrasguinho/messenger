import 'package:server/core/res.dart';
import 'package:shelf/shelf.dart';

import 'package:jwt/jwt.dart';

class JwtService {
  static final Jwt _jwt = Jwt(secret: 'secret', issuer: 'https://tihrasguinho.dev');

  const JwtService._();

  static String sign(String sub, {bool refresh = false}) => _jwt.sign(sub, refresh: refresh);

  static Map<String, dynamic> verify(String token, {bool refresh = false}) => _jwt.verify(token, refresh: refresh);

  static Middleware jwtMiddleware() {
    final availablePaths = <String>['auth/signin', 'auth/signup'];

    return (handler) {
      return (request) {
        try {
          if (availablePaths.contains(request.url.path)) return handler(request);

          final token = request.headers['authorization']?.replaceAll('Bearer ', '') ?? '';

          final payload = verify(token);

          final changed = request.change(context: {'uid': payload['sub']});

          return handler(changed);
        } on JwtException catch (e) {
          return Res.toJson(401, body: {'error': e.error});
        } on Exception catch (e) {
          return Res.toJson(400, body: {'error': e.toString()});
        }
      };
    };
  }
}
