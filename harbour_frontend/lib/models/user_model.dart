class User {
  final int id;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String username;
  final String email;

  const User({
    required this.id,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      middle_name: json['middle_name'],
      last_name: json['last_name'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map toJson() => {
    'id': id,
    'first_name': first_name,
    'middle_name': middle_name,
    'last_name': last_name,
    'username': username,
    'email': email,
  };
}
