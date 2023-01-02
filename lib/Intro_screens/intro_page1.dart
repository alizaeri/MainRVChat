import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';

class IntroPage1 extends StatefulWidget {
  @override
  _OBScreenState createState() => _OBScreenState();
}

class _OBScreenState extends State<IntroPage1> {
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
                    "assets/images/intro1.webp",
                    fit: BoxFit.cover,
                    scale: 2,
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    "Find new friends",
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
                    "With Random VIdeo Chat (RVC), you can connect to all online users around the world and make a video call with them.",
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
