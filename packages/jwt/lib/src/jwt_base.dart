abstract class JwtBase {
  String sign(String sub, {bool refresh});
  Map<String, dynamic> verify(String token, {bool refresh});
}
