import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'leaderboard_viewmodel.dart';

class LeaderBoardView extends StackedView<LeaderBoardViewModel> {
  const LeaderBoardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LeaderBoardViewModel viewModel,
    Widget? child,
  ) {
    return const Scaffold(
      body: Text('LeaderBoard View'),
    );
  }

  @override
  LeaderBoardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LeaderBoardViewModel();
}
