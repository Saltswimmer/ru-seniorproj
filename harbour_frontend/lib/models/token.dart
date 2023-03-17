class Token {
  final String? accessToken;
  final String? tokenType;

  const Token({required this.accessToken, required this.tokenType});

  factory Token.fromJSON(Map<String, dynamic> json) {
    try {
      return Token(
          accessToken: json['access_token'].toString(), tokenType: json['token_type'].toString());
    } catch (e) {
      return const Token(accessToken: null, tokenType: null);
    }
  }
}