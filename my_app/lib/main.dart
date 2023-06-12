import 'package:flutter/material.dart';
import 'mission.dart';
import 'upload.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo'),
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.star),
                    text:
                        "Mission"), // Replace Icons.mission with your preferred icon
                Tab(
                    icon: Icon(Icons.star),
                    text:
                        "Upload"), // Replace Icons.empty with your preferred icon
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Mission(mission: {}), // Your Mission screen
              Upload() // Your empty screen
            ],
          ),
        ),
      ),
    );
  }
}
