// ignore_for_file: library_private_types_in_public_api
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class Mission extends StatefulWidget {
  final Map<String, dynamic> weather;

  const Mission({super.key, required this.weather});

  @override
  _MissionState createState() => _MissionState();
}


Future<List<Map<String, dynamic>>> fetchMissions() async {
  final response = await http.get(Uri.parse(
      'http://192.168.1.102:3000/api/user/647f4871cba2f4670727a9a6/getToday'));
  final Map<String, dynamic> body = jsonDecode(response.body);
  final List<dynamic> missions = body['mission'] as List<dynamic>;
  print(missions);
  return missions
      .map((dynamic mission) => <String, dynamic>{
            'id': mission['_id'],
            'name': mission['name'],
            'description': mission['description'],
            'isDone': mission['isDone'],
          })
      .toList();
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
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ))),
            ),
          );
        },
      ),
    );
  }
}
