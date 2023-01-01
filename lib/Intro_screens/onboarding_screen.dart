import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/main.dart';
import 'package:rvchat/screens/mobile_layout_screen.dart';
import 'package:rvchat/widgets/error.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page4.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onlastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onlastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              //IntroPage3(),
              IntroPage4(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.60),
            child: SmoothPageIndicator(
              controller: _controller,
              effect: const WormEffect(
                dotHeight: 10,
                dotColor: Color(0x44ffffff),
                activeDotColor: Colors.white,
                dotWidth: 35,
                type: WormType.normal,
              ),
              count: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 80, 40, 0),
            child: Container(
              alignment: Alignment.topRight,
              child: onlastPage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const MyApp();
                            },
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ref.watch(userDataAuthProvider).when(
                                    data: (user) {
                                      if (user == null) {
                                        return const LandingScreen();
                                      }
                                      return const MobileLayoutScreen();
                                    },
                                    error: (err, trace) {
                                      return ErrorScreen(
                                        error: err.toString(),
                                      );
                                    },
                                    loading: () => const LoaderW());
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Start",
                          style:
                              TextStyle(color: Color(0xccffffff), fontSize: 18),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(2);
                      },
                      child: const Text(
                        "Skip",
                        style:
                            TextStyle(color: Color(0xccffffff), fontSize: 18),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 80),
            child: Container(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 60,
                child: onlastPage
                    ? GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          "",
                          style:
                              TextStyle(color: Color(0xccffffff), fontSize: 18),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          "Next",
                          style:
                              TextStyle(color: Color(0xccffffff), fontSize: 18),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
