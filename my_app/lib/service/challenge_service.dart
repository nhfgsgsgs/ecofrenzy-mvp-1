import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/models/challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChallengeService {
  Future<List<Challenge>> fetchChallenges() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    final id = prefs.getString('id');

    if (id == null) {
      final response = await http.post(
          Uri.parse(
              'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user'),
          headers: <String, String>{
            'Accept': 'application/json',
          },
          body: {
            'deviceToken': token,
          });
      final Map<String, dynamic> body = jsonDecode(response.body);
      final user = body['user'];
      prefs.setString('id', user['_id']);
    }

    final response = await http.get(Uri.parse(
        'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/${prefs.getString('id')}/getToday'));

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> missions = body['mission'] as List<dynamic>;
    print(missions
        .map((dynamic mission) => Challenge.fromJson(mission))
        .toList());
    return missions
        .map((dynamic mission) => Challenge.fromJson(mission))
        .toList();
  }

  Future<String> updateChallenge(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('id');
    print(userId!);
    final response = await http.put(
      Uri.parse(
          // 'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/updateToday'
          'http://192.168.54.105:3000/api/user/updateToday'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
      body: {
        'userId': userId,
        'missionId': id,
      },
    );
    print(response.body);
    return response.body;
  }
}
