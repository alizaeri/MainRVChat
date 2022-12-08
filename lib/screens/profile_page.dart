import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w800,
                        fontSize: 40,
                        color: white),
                    "Profile"),
                const SizedBox(height: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: white,
                      radius: 75,
                      child: CircleAvatar(
                        backgroundColor: pinkL1,
                        radius: 70,
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
            child: Column(children: [Text("äsdfsadf")]),
          ),
        ],
      ),
    );
  }
}
