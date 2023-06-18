import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/models/challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeService {
  Future<List<Challenge>> getChallenges() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    final response = await http.get(Uri.parse(
        'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/$userId/getToday'));

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> missions = body['mission'] as List<dynamic>;

    return missions
        .map((dynamic mission) => Challenge.fromJson(mission))
        .toList();
  }

  Future<String> updateChallengeStatus(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('id');

    final response = await http.put(
      Uri.parse(
          'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/updateToday'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
      body: {
        'userId': userId,
        'missionId': id,
      },
    );
    return response.body;
  }
}
