import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/models/user_model.dart';
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
  bool rVChat = false;
  UserModel? selectRandomUser;

  @override
  void initState() {
    // ref.read(authControllerProvider).setUserRandomState(false);
    rVChat = true;

    ref.read(authControllerProvider).setUserRandomState(rVChat);

    // jabe ja shod

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    rVChat = false;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'rVChat': rVChat,
    });
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

//   Future<UserModel?> getRandomUserData() async {
//     var list = await FirebaseFirestore.instance.collection('users').get();
//     UserModel? user;

//     if (list != null) {
//       var alldata = list.docs.map((e) => e.fromMap()).toList();
//       final _random = new Random();

// // generate a random index based on the list length
// // and use it to retrieve the element
//     final _random = new Random();

//     }
//     return user;
//   }
  Stream<List<UserModel>> getAllUserStream() {
    List<UserModel> allUser = [];
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      // List<UserModel> allUser = [];
      for (var document in event.docs) {
        allUser.add(UserModel.fromMap(document.data()));
      }
      print(allUser.length);
      return allUser;
    });
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pic.jpg"),
            fit: BoxFit.cover,
          ),
        ),
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
                        backgroundColor: white.withOpacity(0.3),
                        radius: 20,
                        child: const ImageIcon(
                          AssetImage(
                            "assets/icons/prof.png",
                          ),
                          color: white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: white),
                          "25k"),
                      const SizedBox(height: 10),
                      CircleAvatar(
                        backgroundColor: white.withOpacity(0.3),
                        radius: 20,
                        child: Stack(children: [
                          const ImageIcon(
                            AssetImage(
                              "assets/icons/prof.png",
                            ),
                            color: white,
                          ),
                          Positioned(
                            left: 15,
                            top: 2,
                            child: Image.asset(
                              "assets/icons/online_point.png",
                              fit: BoxFit.cover,
                              scale: 7,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: white),
                          "25k"),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: pinkL1,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        minimumSize: const Size.fromHeight(60)
                        //////// HERE
                        ),
                    onPressed: () async {
                      getAllData();
                      if (selectRandomUser != null) {
                        makeCall(ref, context, selectRandomUser!);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                          ),
                          "Randomize"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
