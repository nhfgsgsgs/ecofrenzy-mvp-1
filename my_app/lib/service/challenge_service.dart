import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_app/models/challenge.dart';

class ChallengeService {
  Future<String> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/data.json');
    return jsonData;
  }

  Future<List<Challenge>> fetchChallenges() async {
    final id = jsonDecode(await loadJsonData())['id'];
    final response = await http.get(Uri.parse(
        'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/$id/getToday'));
    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> missions = body['mission'] as List<dynamic>;
    return missions
        .map((dynamic mission) => Challenge.fromJson(mission))
        .toList();
  }

  Future<String> updateChallenge(String id) async {
    final userId = jsonDecode(await loadJsonData())['id'];
    final response = await http.put(
      Uri.parse(
          'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/updateToday'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'missionId': id,
      }),
    );
    return response.body;
  }
}
