import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'challenge_viewmodel.dart';
import 'widgets.dart';

class ChallengeView extends StatelessWidget {
  const ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallengeViewModel>.reactive(
      viewModelBuilder: () => ChallengeViewModel(),
      onViewModelReady: (model) => model.futureToRun(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.challenges.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "There are no challenges available. Keep living sustainably anyway :)",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: model.challenges.map((challenge) {
                return ExpandableCard(challenge: challenge, model: model);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
