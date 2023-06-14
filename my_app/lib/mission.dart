// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
// import web_socket_channel;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

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
  final response = await http.get(Uri.parse(
      'https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/$id/getToday'));
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
  print(response.body);
  return response.body;
}

class _MissionState extends State<Mission> {
  final channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080');

  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    channel.stream.listen(
      (message) {
        print('Connected and received message: $message');
        fetchMissions().then((value) {
          setState(() {
            data = value;
          });
        });
      },
      onError: (error) {
        print('Failed to connect: $error');
      },
      onDone: () {
        print('WebSocket channel is closed.');
      },
    );
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
