import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/app/app.router.dart';
import 'package:my_app/screens/challenge/challenge_view.dart';
import 'package:my_app/screens/feed/feed_view.dart';
import 'package:my_app/screens/leaderboard/leaderboard_view.dart';
import 'package:my_app/screens/profile/profile_view.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: getViewForIndex(viewModel.currentIndex),
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        // use Routes.imagePickerViewRoute
        onPressed: () =>
            Navigator.of(context).pushNamed(Routes.imagePickerView),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: const Color(0xFF46E091),
      title: Stack(
        children: [
          Container(
            width: 450,
            height: 116,
            decoration: const BoxDecoration(
              color: Color(0xFF46E091),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          const Positioned(
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
                  // Navigator.pushNamed(context, '/addfriend');
                },
                child: const Icon(
                  Icons.people,
                  size: 30,
                  color: Colors.black,
                ),
              )),
          Positioned(
            top: 46,
            left: 360,
            child: GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, '/profile');
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
    );
  }

  // Widget _buildBottomNavigationBar(viewModel) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.2),
  //           spreadRadius: 5,
  //           blurRadius: 10,
  //         ),
  //       ],
  //     ),
  //     child: ClipRRect(
  //       borderRadius: const BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //       child: BottomNavigationBar(
  //         type: BottomNavigationBarType.fixed,
  //         backgroundColor: Colors.white,
  //         showSelectedLabels: false,
  //         showUnselectedLabels: false,
  //         selectedItemColor: Colors.redAccent,
  //         unselectedItemColor: Colors.grey.withOpacity(0.5),
  //         currentIndex: viewModel.currentIndex,
  //         onTap: viewModel.setIndex,
  //         items: const [
  //           BottomNavigationBarItem(
  //             label: 'Challenges',
  //             icon: Icon(
  //               Icons.list,
  //               size: 30,
  //             ),
  //           ),
  //           BottomNavigationBarItem(
  //             label: 'Social Feed',
  //             icon: Icon(
  //               Icons.people,
  //               size: 30,
  //             ),
  //           ),
  //           BottomNavigationBarItem(
  //             label: 'Leaderboard',
  //             icon: Icon(
  //               Icons.emoji_events,
  //               size: 30,
  //             ),
  //           ),
  //           BottomNavigationBarItem(
  //             label: 'Profile',
  //             icon: Icon(
  //               Icons.person,
  //               size: 30,
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomNavigationBar(viewModel) {
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
          selectedItemColor: const Color(0xFF46E091),
          unselectedItemColor: Colors.black,
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.setIndex,
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

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const ChallengeView();
      case 1:
        return const LeaderBoardView();
      case 2:
        return const FeedView();
      case 3:
        return const ProfileView();
      default:
        return const ChallengeView();
    }
  }
}
