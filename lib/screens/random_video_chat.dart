// ignore_for_file: unnecessary_new

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/utils/manage_camera.dart';
import "dart:math";

import '../colors.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/call/controller/call_controller.dart';

class RandomeVideoChat extends ConsumerStatefulWidget {
  const RandomeVideoChat({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RandomeVideoChat> createState() => _RandomeVideoChatState();
}

class _RandomeVideoChatState extends ConsumerState<RandomeVideoChat>
    with WidgetsBindingObserver {
  late CameraController cameraController;
  late Future<void> initializeController;
  bool rVChat = false;
  UserModel? selectRandomUser;
  int liveNumbers = 0;

  @override
  void initState() {
    // ref.read(authControllerProvider).setUserRandomState(false);
    rVChat = true;

    ref.read(authControllerProvider).setUserRandomState(rVChat);

    // jabe ja shod

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cameraController = CameraController(
      CameraManager.instance.cameras[1],
      ResolutionPreset.veryHigh,
    );
    initializeController = cameraController.initialize();
  }

  @override
  void dispose() async {
    rVChat = false;
    // ref.read(authControllerProvider).setUserRandomState(false);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'rVChat': rVChat,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        ref.read(authControllerProvider).setUserRandomState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        ref.read(authControllerProvider).setUserRandomState(false);
        break;
    }
  }

  void getAllData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    var listUid = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      if (data['rVChat'] == true &&
          data['uid'] != FirebaseAuth.instance.currentUser!.uid) {
        listUid.add(UserModel.fromMap(data));
      }
    }
    final random = Random();

// generate a random index based on the list length
// and use it to retrieve the element
    setState(() {
      selectRandomUser = listUid[random.nextInt(listUid.length)];
    });
  }

  void makeCall(
      WidgetRef ref, BuildContext context, UserModel selectRandomUser) {
    if (selectRandomUser != null) {
      bool isGroup = false;
      ref.read(callControllerProvider).makeCall(
            context,
            selectRandomUser.name,
            selectRandomUser.uid,
            selectRandomUser.profilePic,
            isGroup,
          );
    }
  }

//   UserModel takeRandome(Stream<List<UserModel>> alluser) {
//     final _random = new Random();

// // generate a random index based on the list length
// // and use it to retrieve the element
//     var user = alluser[_random.nextInt(alluser.length)];
//     return user;
//   }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.height / size.width;
    return Scaffold(
        body: StreamBuilder(
            stream: ref.read(authControllerProvider).allOnlineUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoaderT();
              }
              return StreamBuilder(
                  stream: ref.read(authControllerProvider).allLiveUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return const LoaderT();
                    }
                    List<UserModel> onlineUsers = snapshot.data;
                    List<UserModel> liveUsers = snapshot2.data;
                    int onlineUsersNumbers = 0;

                    onlineUsersNumbers = onlineUsers.length;
                    // liveOnlineNumbers = liveUsers.length;

                    return Stack(
                      children: [
                        FutureBuilder<void>(
                          future: initializeController,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return Column(
                                children: [
                                  Expanded(child: Container())
                                  //child: CameraPreview(cameraController)),
                                ],
                              );
                            } else {
                              // Otherwise, display a loading indicator.
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  //=> Background Linear Gradient
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    grayL1,
                                    grayL1.withOpacity(0),
                                    grayL1.withOpacity(0),
                                    grayL1
                                  ]),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                const CircleAvatar(
                                  backgroundColor: white,
                                  radius: 42,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/icons/avatar.png",
                                    ),
                                    radius: 40,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "yknir",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18,
                                        color: white),
                                    "Elena Johanson"),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              white.withOpacity(0.3),
                                          radius: 20,
                                          child: Image.asset(
                                            "assets/icons/user_chat.png",
                                            fit: BoxFit.cover,
                                            color: white,
                                            scale: 4,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "yknir",
                                                fontWeight: FontWeight.w300,
                                                fontSize: 20,
                                                color: white),
                                            onlineUsersNumbers.toString()),
                                        const SizedBox(height: 10),
                                        CircleAvatar(
                                          backgroundColor:
                                              white.withOpacity(0.3),
                                          radius: 20,
                                          child: Stack(children: [
                                            Image.asset(
                                              "assets/icons/like_icon2.png",
                                              fit: BoxFit.cover,
                                              color: white,
                                              scale: 4,
                                            ),
                                            const Positioned(
                                              left: 20,
                                              top: 3,
                                              child: CircleAvatar(
                                                backgroundColor: pink,
                                                radius: 3,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontFamily: "yknir",
                                                fontWeight: FontWeight.w300,
                                                fontSize: 20,
                                                color: white),
                                            liveUsers.length.toString()),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 0),
                                  child: SizedBox(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: pinkL1,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        minimumSize: const Size.fromHeight(60),
                                        padding: EdgeInsets.all(0),
                                        //////// HERE
                                      ),
                                      onPressed: () async {
                                        getAllData();
                                        if (selectRandomUser != null) {
                                          makeCall(
                                              ref, context, selectRandomUser!);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: "yknir",
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 25,
                                                ),
                                                "Randomize"),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                              color: pinkL2,
                                            ),
                                            height: 60,
                                            width: 80,
                                            child: Image.asset(
                                              "assets/icons/random.png",
                                              color: white,
                                              scale: 5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            })
        // }),
        );
  }
}
