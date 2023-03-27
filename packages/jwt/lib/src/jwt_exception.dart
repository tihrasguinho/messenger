abstract class JwtException implements Exception {
  final String error;
  final StackTrace? stackTrace;

  JwtException(this.error, [this.stackTrace]);
}

class ExpiredJwtException extends JwtException {
  ExpiredJwtException(super.error, [super.stackTrace]);
}

class InvalidSignatureException extends JwtException {
  InvalidSignatureException(super.error, [super.stackTrace]);
}

class InvalidJwtException extends JwtException {
  InvalidJwtException(super.error, [super.stackTrace]);
}
