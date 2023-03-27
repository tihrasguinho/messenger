import 'package:jwt/jwt.dart';

void main() {
  try {
    final jwt = Jwt(secret: 'secret', issuer: 'https://tihrasguinho.dev');

    final token = jwt.sign('unique_uid');

    print(token);
  } on JwtException catch (e) {
    print(e.error);
    print(e.stackTrace);
  }
}
