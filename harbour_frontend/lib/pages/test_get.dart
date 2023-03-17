// import 'package:flutter/material.dart';
// import 'package:harbour_frontend/text_templates.dart';
// import 'package:harbour_frontend/user_model.dart';
// import 'package:harbour_frontend/user_service.dart';

// class TestGet extends StatefulWidget {
//   const TestGet({Key? key}) : super(key: key);

//   @override
//   State<TestGet> createState() => _TestGetState();

// }
// class _TestGetState extends State<TestGet> {

//   Future<List<String>> getUsers () async {
//     UserService uService = UserService();

//     List<User> users = await uService.getUsers();

//     List<String> userStrings = [];
//     users.forEach((user) =>
//       userStrings.add("${user.first_name} ${user.last_name}")
//     );

//     return userStrings;
//   }

//   @override
//   Widget build {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder<List<String>>(
//           future: getUsers(),
//           builder: (context, snapshot) => ,

//         )
//       ),
//     );
//   }
// }