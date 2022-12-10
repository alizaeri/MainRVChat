import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///---------
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  //=> Background Linear Gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [pinkL2, pinkL1, pinkL1]),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: Container()),
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                            color: white),
                        "Profile"),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: whiteW1.withOpacity(0),
                              elevation: 0),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              UserInformationScreen.routeName,
                            );
                          },
                          child: Image.asset(
                            "assets/icons/edit.png",
                            fit: BoxFit.cover,
                            scale: 7,
                            color: white,
                          ),
                        ),
                        const SizedBox(width: 20)
                      ],
                    ))
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                CircleAvatar(
                  backgroundColor: white,
                  radius: size.width * 0.21,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/icons/avatar.png",
                    ),
                    radius: size.width * 0.2,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                    style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w100,
                        fontSize: 40,
                        color: white),
                    "Alen Parish"),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/flow_icon.png",
                      fit: BoxFit.cover,
                      scale: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                      child: Text(
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w300,
                              fontSize: 25,
                              color: white),
                          "105k"),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Image.asset(
                      "assets/icons/like_icon.png",
                      fit: BoxFit.cover,
                      scale: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text(
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w300,
                              fontSize: 25,
                              color: white),
                          "25k"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/lineBg.png",
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: pinkL1),
                      "Full Name"),
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w100,
                          fontSize: 40,
                          color: grayL1),
                      "Alen Parish"),
                  Divider(),
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: pinkL1),
                      "Country"),
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w100,
                          fontSize: 40,
                          color: grayL1),
                      "United State"),
                  Divider(),
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: pinkL1),
                      "Phone Number"),
                  Text(
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w100,
                          fontSize: 40,
                          color: grayL1),
                      "+16505555555"),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
