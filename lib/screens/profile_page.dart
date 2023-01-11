import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/user_information_edit_page.dart';

import '../common/widgets/loaderT.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            return Column(
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
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: GestureDetector(
                                    child: PopupMenuButton<int>(
                                      elevation: 2,
                                      color: grayL1.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Center(
                                            child: Text(
                                              "Sign Out",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: white),
                                            ),
                                          ),
                                        ),
                                      ],
                                      initialValue: 0,
                                      onSelected: (value) async {
                                        print("clik shod");
                                        switch (value) {
                                          case 1:
                                            {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                'isOnline': false,
                                              });
                                              FirebaseAuth.instance.signOut();

                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()),
                                                  (route) => false);

                                              break;
                                            }
                                        }
                                      },
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        UserInformationEditPage.routeName,
                                        arguments: snapshot.data!.country);
                                  },
                                  icon: const Image(
                                    image: Svg('assets/svg/edit.svg'),
                                    fit: BoxFit.cover,
                                    color: white,
                                    width: 22,
                                  ),
                                ),
                                const SizedBox(width: 20)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      CircleAvatar(
                        backgroundColor: white,
                        radius: size.width * 0.21,
                        child: CircleAvatar(
                          backgroundImage: snapshot.data!.profilePic == null
                              ? const AssetImage("assets/images/avatar.webp")
                                  as ImageProvider
                              : NetworkImage(snapshot.data!.profilePic),
                          radius: size.width * 0.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          style: const TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w100,
                              fontSize: 40,
                              color: white),
                          snapshot.data!.name),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: Svg('assets/svg/flow_icon.svg'),
                            fit: BoxFit.cover,
                            color: yellow,
                            width: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                            child: Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: white),
                                snapshot.data!.followers.toString()),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const Image(
                            image: Svg('assets/svg/heart_b.svg'),
                            fit: BoxFit.cover,
                            color: yellow,
                            width: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: Text(
                                style: const TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: white),
                                snapshot.data!.following.toString()),
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
                      children: [
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035,
                                color: pinkL1),
                            "Full Name"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: size.width * 0.08,
                                color: grayL1),
                            snapshot.data!.name),
                        Divider(color: grayL1.withOpacity(0.5)),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035,
                                color: pinkL1),
                            "Country"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: size.width * 0.08,
                                color: grayL1),
                            snapshot.data!.country),
                        Divider(color: grayL1.withOpacity(0.5)),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035,
                                color: pinkL1),
                            "Phone Number"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: size.width * 0.08,
                                color: grayL1),
                            snapshot.data!.phoneNumber),
                        Divider(color: grayL1.withOpacity(0.5)),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035,
                                color: pinkL1),
                            "Email Address"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: size.width * 0.08,
                                color: grayL1),
                            "abhslhei@gmail.com"),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
