class User {
  final String user_id;
  final String username;
  final String email;

  const User({
    required this.user_id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map json) {
    return User(
      user_id: json['user_id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map toJson() => {
        'user_id': user_id,
        'username': username,
        'email': email,
      };
}
