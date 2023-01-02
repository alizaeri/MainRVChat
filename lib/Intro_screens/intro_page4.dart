import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/main.dart';
import 'package:rvchat/widgets/error.dart';

import '../colors.dart';
import '../screens/mobile_layout_screen.dart';

class IntroPage4 extends ConsumerStatefulWidget {
  const IntroPage4({Key? key}) : super(key: key);

  @override
  ConsumerState<IntroPage4> createState() => _OBScreenState4();
}

class _OBScreenState4 extends ConsumerState<IntroPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              //=> Background Linear Gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [white, whiteW1],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 130),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/intro3.webp",
                      fit: BoxFit.cover,
                      scale: 2,
                    ),
                    const SizedBox(height: 80),
                    const Text(
                      "Real Time Massaging",
                      style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: pinkL1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "Real-time chat with the ability to send photos, audio and video files",
                      style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: grayL1.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )),
              GestureDetector(
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
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: pinkL1,
                  child: const Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Homepage {}
