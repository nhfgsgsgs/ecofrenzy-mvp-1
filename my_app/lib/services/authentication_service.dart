import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  Future login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (userId == null) {
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

    print('User logged in');
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    return userId != null;
  }
}
