class User {

  final String username;
  final String email;

  const User({
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }

  Map toJson() => {
    'username': username,
    'email': email,
  };
}
