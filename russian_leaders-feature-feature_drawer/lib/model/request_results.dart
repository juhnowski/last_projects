class AuthResult{
  final AuthError error;
  final String errorMessage;
  final String token;

  AuthResult( this.error, this.token,  this.errorMessage);
}

enum AuthError {
  OK,
  CREDENTIALS,
  SERVER
}