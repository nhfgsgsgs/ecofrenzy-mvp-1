// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class Mission extends StatefulWidget {
  final Map<String, dynamic> mission;

  const Mission({super.key, required this.mission});

  @override
  _MissionState createState() => _MissionState();
}

Future<String> loadJsonData() async {
  String jsonData = await rootBundle.loadString('assets/data.json');
  return jsonData;
}

Future<String> getIPAddress() async {
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type == InternetAddressType.IPv4) {
        return addr.address;
      }
    }
  }
  return '';
}

Future<List<Map<String, dynamic>>> fetchMissions() async {
  final id = jsonDecode(await loadJsonData())['id'];
  final IP = await getIPAddress();
  final response =
      await http.get(Uri.parse('http://$IP:3000/api/user/$id/getToday'));
  final Map<String, dynamic> body = jsonDecode(response.body);
  final List<dynamic> missions = body['mission'] as List<dynamic>;
  return missions
      .map((dynamic mission) => <String, dynamic>{
            'id': mission['_id'],
            'name': mission['name'],
            'description': mission['description'],
            'status': mission['status'],
            'isDone': mission['isDone'],
          })
      .toList();
}

Future<String> updateMission(String id) async {
  final userId = jsonDecode(await loadJsonData())['id'];
  final IP = await getIPAddress();
  final response = await http.put(
    Uri.parse('http://$IP:3000/api/user/updateToday'),
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

class _MissionState extends State<Mission> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    fetchMissions().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            shape: data[index]['isDone']
                ? const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 2.0),
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(data[index]['description']),
                  trailing: data[index]['isDone']
                      ? const Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () {
                            updateMission(data[index]['id']).then((value) {
                              fetchMissions().then((value) {
                                setState(() {
                                  data = value;
                                });
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: Text(
                            data[index]['status'],
                            style: TextStyle(color: Colors.white),
                          ))),
            ),
          );
        },
      ),
    );
  }
}
