import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';
import 'package:rvchat/models/user_model.dart';

class ProfileUserView extends ConsumerStatefulWidget {
  final UserModel selectUser;
  final int following;
  final int followers;
  static const String routeName = '/profile-user-view';

  const ProfileUserView({
    Key? key,
    required this.selectUser,
    required this.following,
    required this.followers,
  }) : super(key: key);
  @override
  ConsumerState<ProfileUserView> createState() => _ProfileUserViewState();
}

class _ProfileUserViewState extends ConsumerState<ProfileUserView> {
  bool isLiked = false;
  // int following = 0;
  // int followers = 0;
  int tempFollowing = 0;
  int tempFollowers = 0;

  @override
  void initState() {
    tempFollowing = widget.following;
    tempFollowers = widget.followers;
    super.initState();
    super.initState();
    checkIfLikedOrNot();
  }

  // void calculateFollow() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('following')
  //       .get();

  //   following = querySnapshot.docs.length;
  //   tempFollowers = following;
  //   QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('following')
  //       .get();
  //   followers = querySnapshot2.docs.length;
  //   tempFollowing = followers;
  // }

  Stream<UserModel> checkIfLikedOrNot() {
    print('!!!!! ejra shod');
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("following")
        .doc(widget.selectUser.uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void makeCall(WidgetRef ref, BuildContext context, UserModel selectUser) {
    bool isGroup = false;
    ref.read(callControllerProvider).makeCall(
          context,
          selectUser.name,
          selectUser.uid,
          selectUser.profilePic,
          isGroup,
        );
  }

  void addUserToFavorit() async {
    if (!isLiked) {
      if (widget.following == tempFollowing) {
        setState(() {
          tempFollowing++;
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('following')
          .doc(widget.selectUser.uid)
          .set(
            widget.selectUser.toMap(),
          );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
            widget.selectUser.toMap(),
          );
    } else {
      if (widget.following != tempFollowing) {
        setState(() {
          tempFollowing--;
        });
      }
      // });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('following')
          .doc(widget.selectUser.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    }
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.selectUser.uid)
    //     .collection('following')
    //     .get();

    // setState(() {
    //   following = querySnapshot.docs.length;
    // });

    // QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.selectUser.uid)
    //     .collection('followers')
    //     .get();

    // setState(() {
    //   followers = querySnapshot2.docs.length;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String uid = widget.selectUser.uid;
    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            return StreamBuilder<UserModel>(
                stream: checkIfLikedOrNot(),
                builder: (context, snapshot2) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoaderT();
                  }
                  if (snapshot2.hasData) {
                    isLiked = true;
                  } else {
                    isLiked = false;
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
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, MobileChatScreen.routeName,
                                            arguments: {
                                              'name': snapshot.data!.name,
                                              'uid': snapshot.data!.uid,
                                              'profilePic':
                                                  snapshot.data!.profilePic,
                                            });
                                      },
                                      icon: Image.asset(
                                        "assets/icons/edit.png",
                                        fit: BoxFit.cover,
                                        color: white,
                                        scale: 8,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        makeCall(
                                            ref, context, widget.selectUser);
                                      },
                                      icon: Image.asset(
                                        "assets/icons/rv.png",
                                        fit: BoxFit.cover,
                                        color: white,
                                        scale: 8,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        addUserToFavorit();
                                      },
                                      icon: isLiked
                                          ? Image.asset(
                                              "assets/icons/like_icon.png",
                                              fit: BoxFit.cover,
                                              color: white,
                                              scale: 8,
                                            )
                                          : Image.asset(
                                              "assets/icons/tick.png",
                                              fit: BoxFit.cover,
                                              color: white,
                                              scale: 8,
                                            ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            CircleAvatar(
                              backgroundColor: white,
                              radius: size.width * 0.21,
                              child: CircleAvatar(
                                backgroundImage: snapshot.data!.profilePic ==
                                        null
                                    ? const AssetImage(
                                            "assets/icons/avatar.png")
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
                                Image.asset(
                                  "assets/icons/flow_icon.png",
                                  fit: BoxFit.cover,
                                  scale: 5,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                                  child: Text(
                                      style: TextStyle(
                                          fontFamily: "yknir",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 25,
                                          color: white),
                                      tempFollowers.toString()),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                IconButton(
                                  onPressed: () {
                                    addUserToFavorit();
                                  },
                                  icon: Image.asset(
                                    "assets/icons/like_icon.png",
                                    fit: BoxFit.cover,
                                    color: white,
                                    scale: 5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Text(
                                      style: TextStyle(
                                          fontFamily: "yknir",
                                          fontWeight: FontWeight.w300,
                                          fontSize: 25,
                                          color: white),
                                      tempFollowing.toString()),
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
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
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
                                      fontSize: size.width * 0.1,
                                      color: grayL1),
                                  snapshot.data!.name),
                              const Divider(),
                              const Text(
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
                                      fontSize: size.width * 0.1,
                                      color: grayL1),
                                  "Iran"),
                              const Divider(),
                              const Text(
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
                                      fontSize: size.width * 0.1,
                                      color: grayL1),
                                  snapshot.data!.phoneNumber),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
