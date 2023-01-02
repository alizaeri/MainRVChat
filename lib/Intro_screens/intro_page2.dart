import 'package:flutter/material.dart';

import '../colors.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _OBScreenState2 createState() => _OBScreenState2();
}

class _OBScreenState2 extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            //=> Background Linear Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [white, whiteW1],
          ),
        ),
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/intro2.webp",
                    fit: BoxFit.cover,
                    scale: 2,
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    "Random Person Video Chat",
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
                    "easy to use and fun, get paired with a random person for video chat then just swipe right to connect with someone",
                    style: TextStyle(
                      fontFamily: "yknir",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: grayL1.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
