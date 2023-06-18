import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:my_app/models/challenge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
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

  Future uploadImage(File image) async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    var uri = Uri.parse(
        "https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/$id/upload");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        filename: image.path.split('/').last,
        contentType: MediaType('image', 'png'),
      ),
    );
    request.fields['deviceToken'] = await messaging.getToken() ?? '';

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded.');
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
    }

    // This will convert the response to a string and print it.
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
