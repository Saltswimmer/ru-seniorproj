// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:harbour_frontend/api/vessel_service.dart';
// import 'package:harbour_frontend/models/session.dart';
// import 'package:harbour_frontend/models/user_model.dart';
// import 'package:provider/provider.dart';

// class UserList extends StatefulWidget {

//   @override
//   _UserListState createState() => _UserListState();
// }

// class _UserListState extends State<UserList> {

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Session>(
//       builder: (context, session, child) {
//         return FutureBuilder(future: VesselService().getUsers(session.token!),builder: (context, snapshot) {
//         if (snapshot.hasData){
//           return ListView.builder(
//           itemCount: snapshot.data!.length,
//           itemBuilder: (BuildContext context, int index) {
//             User user = snapshot.data![index];
//             return ListTile(
//               title: Text(user.username),
//               subtitle: Text(user.email),
//             );
//           },
//         );
//       } else {
//         if (snapshot.hasError) {
//               return Text('${snapshot.error}');
//             } else {
//               return const CircularProgressIndicator();
//           }
//       }});
//       }
//     );
//   }
// }