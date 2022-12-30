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
    cameraController = CameraController(
      CameraManager.instance.cameras[1],
      ResolutionPreset.low,
    );
    initializeController = cameraController.initialize();
    WidgetsBinding.instance.addObserver(this);

    // Next, initialize the controller. This returns a Future.
  }

  @override
  void dispose() async {
    rVChat = false;
    // ref.read(authControllerProvider).setUserRandomState(false);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    cameraController.dispose();

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

                    return FutureBuilder<void>(
                      future: initializeController,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          return Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              AspectRatio(
                                aspectRatio: 3 / 3,
                                child: new CameraPreview(cameraController),
                              ),
                              // CameraPreview(cameraController),
                            ],
                          );
                        } else {
                          // Otherwise, display a loading indicator.
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  });
            })
        // }),
        );
  }
}
