class Token {
  final String? accessToken;
  final String? tokenType;

  const Token({required this.accessToken, required this.tokenType});

  factory Token.fromJSON(Map<String, dynamic> json) {
    return Token(
        accessToken: json['access_token'].toString(),
        tokenType: json['token_type'].toString());
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
      };

  @override
  String toString() {
    return "$tokenType $accessToken";
  }
}
