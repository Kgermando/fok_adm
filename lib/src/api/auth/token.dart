
class Token {
  final int? id;
  // final int expiresIn;
  final String accessToken;
  final String refreshToken;

  Token({
    this.id,
    // required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> jsonMap) {
    return Token(
      id: jsonMap["id"],
      // expiresIn: jsonMap["expiresIn"],
      accessToken: jsonMap["auth_token"],
      refreshToken: jsonMap["refresh_token"],
    );
  }
}