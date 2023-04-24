// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:harbour_frontend/api/user_service.dart';
// import 'package:harbour_frontend/models/session.dart';
// import 'package:harbour_frontend/models/vessel_model.dart';

// class VesselList extends StatefulWidget {

//   @override
//   _VesselListState createState() => _VesselListState();
// }

// class _VesselListState extends State<VesselList> {

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(future: UserService().getVessels(Session.token!),builder: (context, snapshot) {
//     if (snapshot.hasData){
//       return ListView.builder(
//       itemCount: snapshot.data!.length,
//       itemBuilder: (BuildContext context, int index) {
//         Vessel vessel = snapshot.data![index];
//         return ListTile(
//           title: Text(vessel.name),
//         );
//       },
//     );
//   } else {
//     if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         } else {
//           return const CircularProgressIndicator();
//       }
//   }});
//   }
// }