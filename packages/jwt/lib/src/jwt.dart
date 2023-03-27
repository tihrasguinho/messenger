import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:jwt/src/jwt_exception.dart';

import 'jwt_base.dart';

class Jwt implements JwtBase {
  final String secret;
  final String? issuer;
  final Duration tokenExpiration;
  final Duration refreshTokenExpiration;

  const Jwt({
    required this.secret,
    this.issuer,
    this.tokenExpiration = const Duration(hours: 1),
    this.refreshTokenExpiration = const Duration(days: 15),
  });

  @override
  String sign(String sub, {bool refresh = false}) {
    // HEADER

    final headers = <String, dynamic>{
      'alg': 'HS256',
      'typ': 'JWT',
    };

    final headersString = jsonEncode(headers);

    final headerBase64 = base64Url.encode(utf8.encode(headersString)).replaceAll('=', '');

    // PAYLOAD

    final iat = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final exp = refresh ? iat + refreshTokenExpiration.inSeconds : iat + tokenExpiration.inSeconds;

    final payload = <String, dynamic>{
      'sub': sub,
      'iat': iat,
      'exp': exp,
      if (issuer != null) 'iss': issuer,
    };

    final payloadString = jsonEncode(payload);

    final payloadBase64 = base64Url.encode(utf8.encode(payloadString)).replaceAll('=', '');

    // SIGNATURE

    final hmac = Hmac(sha256, utf8.encode(refresh ? '$secret:REFRESH' : secret));
    final digest = hmac.convert(utf8.encode('$headerBase64.$payloadBase64'));
    final signatureBase64 = base64Url.encode(digest.bytes).replaceAll('=', '');

    return '$headerBase64.$payloadBase64.$signatureBase64';
  }

  @override
  Map<String, dynamic> verify(String token, {bool refresh = false}) {
    final regex = RegExp(r'^[0-9a-zA-Z]*\.[0-9a-zA-Z]*\.[0-9a-zA-Z-_]*$');

    if (!regex.hasMatch(token)) throw InvalidJwtException('Invalid or malformed token!', StackTrace.current);

    // HEADER

    final headerBase64 = base64Url.normalize(token.split('.')[0]);
    final headerString = String.fromCharCodes(base64Url.decode(headerBase64));
    final header = Map<String, dynamic>.from(jsonDecode(headerString));

    if (header['alg'] != 'HS256' || header['typ'] != 'JWT') throw InvalidJwtException('Invalid token headers!', StackTrace.current);

    // PAYLOAD

    final payloadBase64 = base64Url.normalize(token.split('.')[1]);
    final payloadString = String.fromCharCodes(base64Url.decode(payloadBase64));
    final payload = Map<String, dynamic>.from(jsonDecode(payloadString));

    final exp = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000, isUtc: true);

    if (exp.isBefore(DateTime.now().toUtc())) throw ExpiredJwtException('Expired token!', StackTrace.current);

    // SIGNATURE

    final hmac = Hmac(sha256, utf8.encode(refresh ? '$secret:REFRESH' : secret));
    final digest = hmac.convert(utf8.encode('${token.split('.')[0]}.${token.split('.')[1]}'));
    final signatureBase64 = base64Url.encode(digest.bytes).replaceAll('=', '');

    if (signatureBase64 != token.split('.')[2]) throw InvalidSignatureException('Invalid signature', StackTrace.current);

    return payload;
  }
}
