import 'package:flutter/material.dart';
import 'package:my_app/screens/challenge/challenge_view.dart';
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
        bottomNavigationBar: _buildBottomNavigationBar(viewModel));
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
    );
  }

  Widget _buildBottomNavigationBar(viewModel) {
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
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.setIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Challenges',
              icon: Icon(
                Icons.list,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Social Feed',
              icon: Icon(
                Icons.people,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
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

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return ChallengeView();
      case 1:
        return ProfileView();
      default:
        return ChallengeView();
    }
  }
}
