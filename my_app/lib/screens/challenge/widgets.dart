import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_app/models/challenge.dart';
import 'package:my_app/screens/challenge/challenge_viewmodel.dart';

class ChallengeSmallCard extends StatelessWidget {
  final Challenge challenge;
  final ChallengeViewModel model;
  final int height;

  ChallengeSmallCard({
    super.key,
    required this.challenge,
    required this.model,
    this.height = 150,
  });

  final listProps = [
    {
      "category": "Energy and Resources",
      "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
      "icon": "assets/images/consumption.png",
    },
    {
      "category": "Transportation",
      "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
      "icon": "assets/images/transportation.png",
    },
    {
      "category": "Consumption",
      "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
      "icon": "assets/images/consumption.png",
    },
    {
      "category": "Waste Management",
      "color": ["#D92849", "#D43653", "#FE4F7A"],
      "icon": "assets/images/waste_management.png",
    },
    {
      "category": "Forestry",
      "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
      "icon": "assets/images/consumption.png",
    },
    {
      "category": "Awareness and Innovation",
      "color": ["#FDAD2D", "#FE875C", "#FFC71F"],
      "icon": "assets/images/consumption.png",
    }
  ];

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height.toDouble(),
          width: 382,
          padding:
              const EdgeInsets.only(left: 10, top: 15, right: 5, bottom: 5),
          margin: const EdgeInsets.only(top: 35),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: getGradientColor(challenge.category.name).sublist(0, 2),
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
                                getIcon(challenge.category.name),
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
                                challenge.category.name,
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
            color: getGradientColor(challenge.category.name).last,
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

class ChallengeBigCard extends ChallengeSmallCard {
  ChallengeBigCard({
    super.key,
    required Challenge challenge,
    required ChallengeViewModel model,
  }) : super(challenge: challenge, model: model, height: 500);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height.toDouble(),
          width: 382,
          padding:
              const EdgeInsets.only(left: 10, top: 15, right: 5, bottom: 5),
          margin: const EdgeInsets.only(top: 35),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: getGradientColor(challenge.category.name).sublist(0, 2),
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
              // Challenge Title and Category
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
                            getIcon(challenge.category.name),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            challenge.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontFamily: "Ridley Grotesk",
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            challenge.category.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontFamily: "Ridley Grotesk",
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Challenge Description
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    challenge.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: "Ridley Grotesk",
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),

              // Accept Challenge Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        getGradientColor(challenge.category.name).last,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  ),
                  onPressed: () {
                    model.updateChallengeStatus(challenge.id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Accept Challenge',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Ridley Grotesk",
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({Rect? begin, Rect? end}) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin?.left ?? 0.0, end?.left ?? 0.0, elasticCurveValue)!,
      lerpDouble(begin?.top ?? 0.0, end?.top ?? 0.0, elasticCurveValue)!,
      lerpDouble(begin?.right ?? 0.0, end?.right ?? 0.0, elasticCurveValue)!,
      lerpDouble(begin?.bottom ?? 0.0, end?.bottom ?? 0.0, elasticCurveValue)!,
    );
  }
}

class ExpandableCard extends StatelessWidget {
  final Challenge challenge;
  final ChallengeViewModel model;

  const ExpandableCard(
      {super.key, required this.challenge, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) {
              return ChallengeBigCard(
                challenge: challenge,
                model: model,
              );
            },
          ),
        );
      },
      child: Hero(
          tag: "challenge-card-${challenge.id}",
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: ChallengeSmallCard(
            challenge: challenge,
            model: model,
          )),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => const Color.fromARGB(221, 215, 211, 211);

  @override
  Duration get transitionDuration => const Duration(microseconds: 1000);

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Center(
      child: _builder(context),
    );
  }

  @override
  String? get barrierLabel => "Challenge Detail open";
}
