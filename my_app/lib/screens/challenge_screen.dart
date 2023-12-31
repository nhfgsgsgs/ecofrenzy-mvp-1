import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/service/challenge_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/challenge_notifier.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService challengeService = ChallengeService();
  late Future<List<Challenge>> futureChallenges;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> showLoading() {
    return EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  @override
  void initState() {
    super.initState();
    futureChallenges = challengeService.fetchChallenges();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // When a new message arrives, fetch the challenges again
      EasyLoading.dismiss();
      print(message.data['default']);

      context.read<ChallengeModel>().fetchChallenges();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${message.data['default']}'),
            content: Text('You have a new message: ${message.data['default']}'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    futureChallenges = challengeService.fetchChallenges();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
    showLoading();
    setState(() {
      futureChallenges = challengeService.fetchChallenges();
    });

    print(response.statusCode);
    print(response.reasonPhrase);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<bool> isAllPicked(Future<List<Challenge>> futureChallenges) async {
    List<Challenge> challenges = await futureChallenges;
    for (var challenge in challenges) {
      if (challenge.status == 'pending') {
        return true;
      }
    }
    return false;
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
            height: 56,
            width: 382,
            padding: const EdgeInsets.only(top: 12.5),
            margin: EdgeInsets.only(left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Stack(
              children: [
                Container(
                  height: 41,
                  width: 382,
                   decoration:  BoxDecoration (
                    color:  Color(0x42ffffff),
                    borderRadius:  BorderRadius.circular(20),
                    boxShadow:  [
                      BoxShadow(
                        color:  Color(0x19000000),
                        offset:  Offset(0, 0),
                        blurRadius:  0,
                      ),
                      BoxShadow(
                        color:  Color(0x19000000),
                        offset:  Offset(0, 2),
                        blurRadius:  1.5,
                      ),
                      BoxShadow(
                        color:  Color(0x16000000),
                        offset:  Offset(0, 6),
                        blurRadius:  3,
                      ),
                    ],
                  ),

                ),
              ],
            ),           
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
            decoration: const BoxDecoration(
              color: Colors.blue,
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.blueAccent,
      //   onPressed: uploadImage,
      //   child: const Icon(Icons.add),
      // ),
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
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 10,
            blurRadius: 15,
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
          selectedItemColor: Color(0xFF46E091),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              label: 'Achievements',
              icon: Icon(
                FontAwesomeIcons.book,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Challenges',
              icon: Icon(
                FontAwesomeIcons.compass,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Achievements',
              icon: Icon(
                FontAwesomeIcons.ticketAlt,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Challenges',
              icon: Icon(
                FontAwesomeIcons.trophy,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Color(0xFF46E091),
      title: Stack(
        children: [
          Container(
            width: 450,
            height: 116,
            decoration: BoxDecoration(
              color: const Color(0xFF46E091),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 95,
            child: Align(
                child: Text(
              "Today Challenges",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Ridley Grotesk",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )),
          ),
          Positioned(
              top: 50,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/addfriend');
                },
                child: Icon(Icons.people, size: 30, color: Colors.black,),
              )),
          Positioned(
            top: 46,
            left: 360,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Image.asset(
                'assets/images/avatar.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
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
        "color": ["#E52BDD", "#FF51CE", "#FB8DF0"],
        "icon": "assets/images/Energy and Resources.png",
      },
      {
        "category": "Transportation",
        "color": [
          "#7717F3",
          "#8E37FF",
          "#BE61F8",
        ],
        "icon": "assets/images/transportation.png",
      },
      {
        "category": "Consumption",
        "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
        "icon": "assets/images/consumption.png",
      },
      {
        "category": "Waste management",
        "color": ["#D92849", "#D43653", "#FE4F7A"],
        "icon": "assets/images/waste_management.png",
      },
      {
        "category": "Forestry",
        "color": ["#08BB70", "#1AE16A", "#65EDA4"],
        "icon": "assets/images/forestry.png",
      },
      {
        "category": "Awareness and Innovation",
        "color": ["#196AE3", "#2094E8", "#71CCFF"],
        "icon": "assets/images/Awareness and Innovation.png",
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

    String getIcon(String category) {
      for (var i = 0; i < listProps.length; i++) {
        if (listProps[i]["category"] == category) {
          return listProps[i]["icon"] as String;
        }
      }
      return "assets/images/consumption.png"; // default icon
    }

    return Stack(
      children: [
        Container(
          height: 148,
          width: 382,
          padding:
              const EdgeInsets.only(left: 10, top: 15, right: 5, bottom: 5),
          margin: const EdgeInsets.only(top: 35),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: getGradientColor(challenge.category).sublist(0, 2),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 0,
                offset: Offset(0, 0),
              ),
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 8,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x0c000000),
                blurRadius: 11,
                offset: Offset(0, 18),
              ),
              BoxShadow(
                color: Color(0x02000000),
                blurRadius: 13,
                offset: Offset(0, 33),
              ),
              BoxShadow(
                color: Color(0x00000000),
                blurRadius: 14,
                offset: Offset(0, 51),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 5, 20),
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 49,
                              height: 49,
                              child: Image.asset(
                                getIcon(challenge.category),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                challenge.name,
                                style: const TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontFamily: "Ridley Grotesk",
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                challenge.category,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontFamily: "Ridley Grotesk"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, top: 4, bottom: 5),
          height: 30,
          width: 382,
          margin: const EdgeInsets.only(top: 154),
          decoration: BoxDecoration(
            color: getGradientColor(challenge.category).last,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: const Text(
            "View More >>>",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: "Ridley Grotesk SemiBold",
            ),
          ),
        )
      ],
    );
  }
}
