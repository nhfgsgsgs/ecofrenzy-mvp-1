import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/service/challenge_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/challenge_notifier.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService challengeService = ChallengeService();
  late Future<List<Challenge>> futureChallenges;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    futureChallenges = challengeService.fetchChallenges();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // When a new message arrives, fetch the challenges again
      context.read<ChallengeModel>().fetchChallenges();
      setState(() {
        futureChallenges = challengeService.fetchChallenges();
      });
    });
  }

  Future uploadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected.');
      return;
    }

    File file = File(pickedFile.path);
    print(file.path);

    var uri = Uri.parse(
        "https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/$id/upload");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png')));
    request.fields['deviceToken'] = await messaging.getToken() ?? '';

    var response = await request.send();
    setState(() {
      futureChallenges = challengeService.fetchChallenges();
    });

    print(response.statusCode);
    print(response.reasonPhrase);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // white container with shadow
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Challenges',
                  style: TextStyle(
                    fontFamily: 'Ridley Grotesk',
                    color: Colors.black,
                    fontSize: 26,
                  ),
                ),
                FutureBuilder<List<Challenge>>(
                  future: futureChallenges,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text('Error loading challenges');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildChallengeCard(
                              context, snapshot.data![index]);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      )),
      // bottomNavigationBar: _buildBottomNavigationBarTest(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        onPressed: uploadImage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              label: 'Challenges',
              icon: Icon(
                Icons.list,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Achievements',
              icon: Icon(
                Icons.emoji_events,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            margin: const EdgeInsets.only(left: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Hi, Luong!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      actions: const [
        Icon(
          Icons.more_vert,
          color: Colors.black,
          size: 40,
        )
      ],
    );
  }

  // print the challenge card
  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    final listProps = [
      {
        "category": "Energy and Resources",
        "color": [
          "#000000",
          "#000001",
        ],
        "icon": "assets/images/.png",
      },
      {
        "category": "Transportation",
        "color": [
          "#7717F3",
          "#660ED9",
        ],
        "icon": "assets/images/transportation.png",
      },
      {
        "category": "Consumption",
        "color": [
          "#FDAD2D",
          "#FE875C",
        ],
        "icon": "assets/images/consumption.png",
      },
      {
        "category": "Waste management",
        "color": [
          "#D92849",
          "#D43653",
        ],
        "icon": "assets/images/waste management.png",
      },
      {
        "category": "Forestry",
        "color": [
          "#000000",
          "#000001",
        ],
        "icon": "assets/images/.png",
      },
      {
        "category": "Awareness and Innovation",
        "color": [
          "#000000",
          "#000001",
        ],
        "icon": "assets/images/.png",
      }
    ];

    // get the color of the category
    List<Color> getGradientColor(String category) {
      for (var i = 0; i < listProps.length; i++) {
        if (listProps[i]["category"] == category) {
          List<String>? hexColor = listProps[i]["color"] as List<String>?;
          List<Color> colors = [];
          for (var i = 0; i < hexColor!.length; i++) {
            hexColor[i] = hexColor[i].replaceAll("#", "");
            colors.add(Color(int.parse('FF${hexColor[i]}', radix: 16)));
          }
          return colors;
        }
      }
      return [const Color(0xFFFF0000)]; // default color
    }

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColor(challenge.category),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        // tileColor: getColor(challenge.category), // set background color here
        title: Text(challenge.name,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        subtitle: Text(challenge.description,
            style: const TextStyle(
                color: Colors.white, fontFamily: "Ridley Grotesk")),
        trailing: challenge.isDone
            ? const Icon(Icons.check, color: Colors.green)
            : ElevatedButton(
                onPressed: () {
                  if (challenge.status != "Pending" &&
                      challenge.status != "Picked") {
                    challengeService.updateChallenge(challenge.id).then((_) {
                      setState(() {
                        futureChallenges = challengeService.fetchChallenges();
                      });
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(
                  challenge.status,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
