class User {
  final int id;
  final String first_name;
  final String last_name;
  final String user_name;

  const User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.user_name,
  });


  factory User.fromJson(Map json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      user_name: json['user_name']
    );
  }
}