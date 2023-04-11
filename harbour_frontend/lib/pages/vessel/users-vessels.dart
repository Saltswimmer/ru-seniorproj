import 'package:flutter/material.dart';

//THIS FILE IS CURRENTLY STANDALONE AND WILL HAVE TO BE INTEGRATED
//TO INCLUDE THE CORRECT DATA STRUCTURES AND JSON REQUESTS FROM
//VESSELS.dart FILE

class User {
  String name;
  String email;
  String profileImage;

  User(this.name, this.email, this.profileImage);
}

class UserList extends StatelessWidget {
  final List<User> users;

  UserList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        User user = users[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.profileImage)),
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<User> exampleUsers = [
      User("John Doe", "johndoe@example.com", "https://example.com/profile_image1.jpg"),
      User("Jane Smith", "janesmith@example.com", "https://example.com/profile_image2.jpg"),
      User("Bob Johnson", "bobjohnson@example.com", "https://example.com/profile_image3.jpg"),      // Add more example users here...
    ];

    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(title: Text('User List')),
        body: UserList(users: exampleUsers),
      ),
    );
  }
}