import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/main.dart';
import 'package:rvchat/widgets/error.dart';

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
              colors: [
                Color(0xffb5e48c),
                Color(0xff34a0a4),
                Color(0xff1a759f),
                Color(0xff184e77),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  color: const Color(0xffffffff),
                  child: const Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Color(0xff184e77),
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
