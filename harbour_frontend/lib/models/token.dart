import 'dart:convert';

class Token {
  final Map header;
  final Map payload;
  final Map signature;

  const Token(
      {required this.header, required this.payload, required this.signature});

  factory Token.fromBase64(String jwt) {
    List<Map> decodedToken = [];
    jwt.split(".").forEach((element) => decodedToken.add(
        json.decode(utf8.decode(base64.decode(base64.normalize(element))))));

    try {
      return Token(
          header: decodedToken[0],
          payload: decodedToken[1],
          signature: decodedToken[2]);
    } catch (e) {
      return const Token(header: {}, payload: {}, signature: {});
    }
  }
}
