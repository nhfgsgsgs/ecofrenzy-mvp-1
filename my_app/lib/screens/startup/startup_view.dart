import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_app/screens/home/home_view.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        height: 844 * fem,
        child: Container(
          padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0 * fem),
          width: 565 * fem,
          height: 907 * fem,
          child: Stack(
            children: [
              const Image(
                height: 1400,
                width: 600,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/Artboard-1-1.png'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    0 * fem, 100 * fem, 0 * fem, 31.55 * fem),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 2.05 * fem),
                      width: 416 * fem,
                      height: 300 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // vectorS3i (29:127)
                            left: 212 * fem,
                            top: 190 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 187 * fem,
                                height: 119 * fem,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 390 * fem,
                                height: 312 * fem,
                                child: Image.asset(
                                  'assets/images/love-the-earth-1.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // Div 02
                      margin: EdgeInsets.fromLTRB(
                          10 * fem, 0 * fem, 0 * fem, 0 * fem),
                      width: 380 * fem,
                      height: 379.4 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // button
                            left: 270 * fem,
                            top: 62 * fem,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: SizedBox(
                                width: 67 * fem,
                                height: 130 * fem,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageFiltered(
                                      // rectangle264d1i (18:2241)
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 21.6666660309 * fem,
                                        sigmaY: 21.6666660309 * fem,
                                      ),
                                    ),
                                    TextButton(
                                      // group121556vt (18:2242)
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                animationTime,
                                                child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.fastOutSlowIn,
                                                )),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                animationTime) {
                                              return const HomeView();
                                            },
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            17.81 * fem,
                                            20.84 * fem,
                                            20.83 * fem,
                                            20.99 * fem),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7367f0),
                                          borderRadius: BorderRadius.circular(
                                              27.4444446564 * fem),
                                        ),
                                        child: Center(
                                          // group11900a5N (18:2244)
                                          child: SizedBox(
                                            width: 16.25 * fem,
                                            height: 20.05 * fem,
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 41 * fem,
                            top: 51.94921875 * fem,
                            child: SizedBox(
                              width: 200 * fem,
                              height: 180 * fem,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // makegreenfunCMe (18:2248)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 0 * fem, 8 * fem),
                                    constraints: BoxConstraints(
                                      maxWidth: 174 * fem,
                                    ),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        fontFamily: 'Clash',
                                        fontSize: 32 * ffem,
                                        height: 1.25 * ffem / fem,
                                        color: const Color(0xff2b2945),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      child: const Text('Make Green Fun'),
                                    ),
                                  ),
                                  DefaultTextStyle(
                                    // letsdiscovertheworldtogether4P (18:2249)
                                    style: TextStyle(
                                      fontFamily: 'Clash',
                                      fontSize: 16 * ffem,
                                      height: 1.25 * ffem / fem,
                                      color: const Color(0xff73848c),
                                    ),
                                    // letsdiscovertheworldtogether4P (18:2249)
                                    child: const Text(
                                        'Let\'s discover the world together!'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            // vector9gC (28:3103)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 289 * fem,
                                height: 198 * fem,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                // waveyoe (28:3098)
                left: 0 * fem,
                top: 744.5499267578 * fem,
                child: Align(
                  child: SizedBox(
                    width: 417 * fem,
                    height: 99.9 * fem,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
