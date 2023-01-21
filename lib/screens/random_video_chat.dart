// ignore_for_file: unnecessary_new

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rvchat/add_helper.dart';
import 'package:rvchat/features/call/repository/call_repository.dart';

import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/utils/manage_camera.dart';
import "dart:math";
import 'package:wakelock/wakelock.dart';
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
  UserModel? selectFakeRandomUser;
  int liveNumbers = 0;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  int every5Times = 1;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    Wakelock.enable();
    // ref.read(authControllerProvider).setUserRandomState(false);
    rVChat = true;

    ref.read(authControllerProvider).setUserRandomState(rVChat);

    // jabe ja shod

    super.initState();
    cameraController = CameraController(
      CameraManager.instance.cameras[1],
      ResolutionPreset.ultraHigh,
    );
    initializeController = cameraController.initialize();
    WidgetsBinding.instance.addObserver(this);
    deletefIsBusy();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void deletefIsBusy() async {
    await FirebaseFirestore.instance
        .collection('call')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  @override
  void dispose() async {
    rVChat = false;

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
    ref.read(callRepositoryProvider).active(true);

    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    var listUid = [];
    var listFakeUid = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      if (data['rVChat'] == true &&
          data['uid'] != FirebaseAuth.instance.currentUser!.uid &&
          data['isFake'] == false) {
        listUid.add(UserModel.fromMap(data));
      } else if (data['isFake'] == true) {
        // listFakeUid.add(UserModel.fromMap(data));
      }
    }
    final random = Random();

// generate a random index based on the list length
// and use it to retrieve the element
    try {
      selectRandomUser = listUid[random.nextInt(listUid.length)];
      // selectFakeRandomUser = listFakeUid[random.nextInt(listUid.length)];
    } catch (e) {
      selectRandomUser = null;
      // selectFakeRandomUser = null;
    }
    if (selectRandomUser != null) {
      makeCall(ref, context, selectRandomUser!);
    } else if (selectFakeRandomUser != null) {
      // makeCall(ref, context, selectFakeRandomUser!);
    }
  }

  void makeCall(
      WidgetRef ref, BuildContext context, UserModel selectRandomUser) {
    bool isGroup = false;
    ref.read(callControllerProvider).makeCall(
          context,
          selectRandomUser.name,
          selectRandomUser.uid,
          selectRandomUser.profilePic,
          isGroup,
        );
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
        body: Stack(children: [
      FutureBuilder<void>(
        future: initializeController,
        builder: (context, snapshot1) {
          if (snapshot1.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                Transform.scale(
                    scale: 1.3, child: CameraPreview(cameraController)),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      // liveOnlineNumbers = liveUsers.length;

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
                StreamBuilder<UserModel>(
                    stream: ref.read(authControllerProvider).userDataById(uid),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return Column(
                          children: const [
                            CircleAvatar(
                              backgroundColor: white,
                              radius: 42,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/avatar.webp",
                                ),
                                radius: 40,
                              ),
                            ),
                            Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                    color: white),
                                'User Name'),
                          ],
                        );
                      }
                      // UserModel currentUser = snapshot.data!;
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: white,
                            radius: 42,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot2.data!.profilePic,
                              ),
                              radius: 40,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  color: white),
                              snapshot2.data!.name),
                        ],
                      );
                    }),
                const SizedBox(height: 10),
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
                          child: const Image(
                            image: Svg('assets/svg/users.svg'),
                            fit: BoxFit.cover,
                            color: white,
                            width: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        StreamBuilder(
                          stream:
                              ref.read(authControllerProvider).allOnlineUsers(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot3) {
                            if (snapshot3.connectionState ==
                                ConnectionState.waiting) {
                              // If the Future is complete, display the preview.
                              return const Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: white),
                                  '+100');
                            } else if (snapshot3.hasData) {
                              List<UserModel> onlineUsers = snapshot3.data;
                              return Text(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: white),
                                  onlineUsers.length.toString());
                            } else {
                              return const Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: white),
                                  '+100');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        CircleAvatar(
                          backgroundColor: white.withOpacity(0.3),
                          radius: 20,
                          child: const Image(
                            image: Svg('assets/svg/discussion.svg'),
                            //fit: BoxFit.cover,
                            color: white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        StreamBuilder(
                          stream:
                              ref.read(authControllerProvider).allLiveUsers(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot4) {
                            if (snapshot4.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                    color: white),
                                '20k',
                              );
                            } else {
                              List<UserModel> liveUsers = snapshot4.data;
                              return Text(
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                    color: white),
                                liveUsers.length.toString(),
                              );
                            }

                            // liveOnlineNumbers = liveUsers.length;
                          },
                        ),
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
                            borderRadius: BorderRadius.circular(15.0)),
                        minimumSize: const Size.fromHeight(60),
                        padding: const EdgeInsets.all(0),
                        //////// HERE
                      ),
                      onPressed: () async {
                        every5Times++;
                        if (every5Times % 5 == 0) {
                          _showInterstitialAd();
                        }
                        if (!ref
                            .watch(callRepositoryProvider)
                            .activeButtonRVChat) {
                          getAllData();
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
                                bottomRight: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: pinkL2,
                            ),
                            height: 60,
                            width: 80,
                            child: Image(
                              image: Svg('assets/svg/random.svg'),
                              //fit: BoxFit.cover,
                              color: ref
                                      .read(callRepositoryProvider)
                                      .activeButtonRVChat
                                  ? white.withOpacity(0.1)
                                  : white,
                              width: 30,
                              height: 30,
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
          ))

      // }),
    ]));
  }
}
