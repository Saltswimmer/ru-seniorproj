import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:harbour_frontend/api/user_service.dart';
import 'package:harbour_frontend/models/message.dart';
import 'package:harbour_frontend/models/user_model.dart';
import 'package:harbour_frontend/models/token.dart';
import 'package:harbour_frontend/models/vessel_model.dart';
import 'package:localstorage/localstorage.dart';

import '../models/session.dart';
import '../models/vessel_model.dart';

class VesselService {
  final Dio dio = Dio();

  final String server = 'http://localhost:1323';

  VesselService();


  Future<List<User>> getUsers(Session session) async {
    try {
      final res = await dio.get('$server/vessel/members',
          data: {"vessel": session.currentVessel!.vessel_id},
          options: Options(headers: {'Authorization': session.token.toString()}));

      print(res.data);
      List<dynamic> data = res.data['users'];
      return data.map((userJson) => User.fromJson({"username":userJson["username"], "email":""})).toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve users from vessel'));
    }
  }

  Future<List<Vessel>> search(Session session, String name) async {
    try {
      final res = await dio.get('$server/vessel/search',
          data: {'name': name},
          options:
              Options(headers: {'Authorization': session.token.toString()}));

      print(res.data['vessels']);
      return (res.data['vessels'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .map((e) => Vessel.fromJson(e))
          .toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Search failed'));
    }
  }

  Future<Vessel> createVessel(Session session, String name) async {
    try {
      final res = await dio.post('$server/vessel/new',
          data: {'name': name},
          options:
              Options(headers: {'Authorization': session.token.toString()}));

      print(res);
      return Vessel.fromJson(res.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to create vessel'));
    }
  }

  Future<void> sendMessage(Session session, String body) async {
    try {
      await dio.post('$server/vessel/send/${session.currentVessel!.vessel_id}',
          data: {'body': body},
          options:
              Options(headers: {'Authorization': session.token.toString()}));
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve messages'));
    }
  }

  Future<List<Message>?> getMessages(Session session) async {
    print('$server/vessel/messages/${session.currentVessel!.vessel_id}');
    try {
      final res = await dio.get(
          '$server/vessel/messages/${session.currentVessel!.vessel_id}',
          options:
              Options(headers: {'Authorization': session.token.toString()}));

      print(res.data['messages']);
      List<dynamic>? messages = res.data['messages'];
      if (messages == null) {
        return null;
      }
      return messages
          .map((msg) => Message(
              body: msg['body'],
              sender: msg['sender'],
              timestamp: DateTime.parse(msg['timestamp'])))
          .toList()
          .reversed
          .toList();
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve messages'));
    }
  }

  Future<void> joinVessel(Session session, Vessel v) async {
    try {
      final res = await dio.post('$server/vessel/join',
          data: {'vessel_id': v.vessel_id},
          options:
              Options(headers: {'Authorization': session.token.toString()}));
    } on DioError catch (e) {
      print(e.message);
      return Future.error(Exception('Unable to retrieve messages'));
    }
  }
}
