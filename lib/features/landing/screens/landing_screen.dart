import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/custom_button.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);
  void navigationToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      //=> Background Linear Gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [pinkL2, pinkL1, pinkL1]),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                            color: white),
                        "Welcome!"),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Image.asset(
                            "assets/images/main.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: white),
                        "for read our polices please touch"),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: yellow),
                        "RVChat Polices"),
                    Image.asset(
                      "assets/images/lineBg.png",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: grayL1),
                    "If you agree to our \n polices touch continue to start RVChat"),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SizedBox(
                    child: ElevatedButton(
                      child: const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                          "CONTINUE"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pinkL1,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: const Size.fromHeight(60)
                          //////// HERE
                          ),
                      onPressed: () => navigationToLoginScreen(context),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 15,
                  child: Image.asset(
                    "assets/images/alphadronLogo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }
}// dagighe 1:38:54
