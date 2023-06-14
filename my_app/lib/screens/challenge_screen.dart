import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/service/challenge_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({Key? key}) : super(key: key);

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final ChallengeService challengeService = ChallengeService();
  late Future<List<Challenge>> futureChallenges;

  @override
  void initState() {
    super.initState();
    futureChallenges = challengeService.fetchChallenges();
  }

  Future uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected.');
      return;
    }

    File file = File(pickedFile.path);
    print(file.path);

    var uri = Uri.parse(
        "https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/647f4871cba2f4670727a9a6/upload");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png')));

    var response = await request.send();

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
      body: Column(
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
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
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
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.green,
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
          selectedItemColor: Colors.blueAccent,
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

  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Text(challenge.name,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        trailing: challenge.isDone
            ? const Icon(Icons.check, color: Colors.green)
            : ElevatedButton(
                onPressed: () {
                  challengeService.updateChallenge(challenge.id).then((_) {
                    setState(() {
                      futureChallenges = challengeService.fetchChallenges();
                    });
                  });
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
