import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rvchat/add_helper.dart';
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
  late final InterstitialAd interAd;
  final String interAdUnitId = 'ca-app-pub-5708852178580221/4054487003';
  bool isLiked = false;
  // int following = 0;
  // int followers = 0;
  int tempFollowing = 0;
  bool toggleBlock = false;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
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

  Stream<UserModel> checkIfIsBlockedOrNot() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("block")
        .doc(widget.selectUser.uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Stream<UserModel> isCalling() {
    return FirebaseFirestore.instance
        .collection("call")
        .doc(FirebaseAuth.instance.currentUser!.uid)
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
    int following = 0;
    int followers = 0;
    void calculate() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .collection('followers')
          .get();

      followers = querySnapshot.docs.length;
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('following')
          .get();
      following = querySnapshot2.docs.length;
    }

    if (!isLiked) {
      if (tempFollowing < widget.following + 1) {
        setState(() {
          tempFollowing++;
        });
      }
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .collection('followers')
          .get();

      followers = querySnapshot.docs.length;
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('following')
          .get();
      following = querySnapshot2.docs.length;
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'following': following + 1});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .update({'followers': followers + 1});
    } else {
      if (tempFollowing == widget.following ||
          tempFollowing == widget.following + 1) {
        setState(() {
          tempFollowing--;
        });
      }

      // });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .collection('followers')
          .get();

      followers = querySnapshot.docs.length;
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('following')
          .get();
      following = querySnapshot2.docs.length;

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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectUser.uid)
          .update({'followers': followers - 1});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'following': following - 1});
    }
  }

  void blockUser() async {
    var blockUser = UserModel(
        name: widget.selectUser.name, //check out
        uid: widget.selectUser.uid,
        profilePic: widget.selectUser.profilePic,
        isOnline: false,
        rVChat: false,
        phoneNumber: '',
        following: 0,
        followers: 0,
        country: '0',
        email: 'email',
        isFake: false,
        coin: 0,
        lastOnlineTime: DateTime.now(),
        videoLink: '',
        groupId: []);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('block')
        .doc(widget.selectUser.uid)
        .set(
          blockUser.toMap(),
        );
  }

  void unBlockUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('block')
        .doc(widget.selectUser.uid)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String uid = widget.selectUser.uid;
    return Scaffold(
      body: //StreamBuilder<DocumentSnapshot>(
          //    stream: ref.watch(callControllerProvider).callStream,
          // builder: (context, snapshot) {
          //   if (snapshot.hasData && snapshot.data!.data() != null) {
          //     Call call =
          //         Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          //     if (!call.hasDialled) {
          //     }

          // return
          StreamBuilder<UserModel>(
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
                        print(snapshot2.data!.name);
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
                                    IconButton(
                                      onPressed: () {
                                        if (Navigator.canPop(context)) {
                                          _showInterstitialAd();

                                          Navigator.pop(context);
                                        } else {
                                          SystemNavigator.pop();
                                          _showInterstitialAd();
                                        }
                                      },
                                      icon: const Image(
                                        image: Svg('assets/svg/back.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                        width: 18,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "yknir",
                                                fontWeight: FontWeight.w800,
                                                fontSize: 40,
                                                color: white),
                                            "Profile"),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: GestureDetector(
                                        child: PopupMenuButton<int>(
                                          elevation: 2,
                                          color: grayL1.withOpacity(0.8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                children: [
                                                  !isLiked
                                                      ? const Image(
                                                          image: Svg(
                                                              'assets/svg/heart.svg'),
                                                          fit: BoxFit.cover,
                                                          color: white,
                                                          width: 16,
                                                        )
                                                      : const Image(
                                                          image: Svg(
                                                              'assets/svg/heart_b.svg'),
                                                          fit: BoxFit.cover,
                                                          color: yellow,
                                                          width: 16,
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    !isLiked
                                                        ? "like user"
                                                        : "Unlike user",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuDivider(),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: [
                                                  StreamBuilder<UserModel>(
                                                    stream:
                                                        checkIfIsBlockedOrNot(),
                                                    builder:
                                                        (context, snapshot3) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const LoaderT();
                                                      }
                                                      if (snapshot3.hasData) {
                                                        toggleBlock = true;
                                                      } else {
                                                        toggleBlock = false;
                                                      }
                                                      return toggleBlock
                                                          ? const Image(
                                                              width: 16,
                                                              image: Svg(
                                                                  'assets/svg/block.svg'),
                                                              fit: BoxFit.cover,
                                                              color: white,
                                                            )
                                                          : const Image(
                                                              width: 16,
                                                              image: Svg(
                                                                  'assets/svg/unblock.svg'),
                                                              fit: BoxFit.cover,
                                                              color: white,
                                                            );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    !toggleBlock
                                                        ? "Block user"
                                                        : "Unblock user",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          initialValue: 0,
                                          onSelected: (value) async {
                                            switch (value) {
                                              case 1:
                                                {
                                                  addUserToFavorit();
                                                  break;
                                                }
                                              case 2:
                                                {
                                                  if (!toggleBlock) {
                                                    blockUser();
                                                  } else {
                                                    unBlockUser();
                                                  }

                                                  break;
                                                }
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 0, 30, 0),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                      color: white,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height * 0.02),
                                CircleAvatar(
                                  backgroundColor: white,
                                  radius: size.width * 0.21,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        snapshot.data!.profilePic == null
                                            ? const AssetImage(
                                                    "assets/images/avatar.webp")
                                                as ImageProvider
                                            : NetworkImage(
                                                snapshot.data!.profilePic),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 0, 0),
                                      child: Text(
                                          style: const TextStyle(
                                              fontFamily: "yknir",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 25,
                                              color: white),
                                          snapshot.data!.following.toString()),
                                    ),
                                    const SizedBox(width: 40),
                                    IconButton(
                                      onPressed: () {
                                        addUserToFavorit();
                                      },
                                      icon: !isLiked
                                          ? Image(
                                              image:
                                                  Svg('assets/svg/heart.svg'),
                                              //fit: BoxFit.cover,
                                              color: white,
                                              width: 20,
                                              height: 20,
                                            )
                                          : Image(
                                              image:
                                                  Svg('assets/svg/heart_b.svg'),
                                              //fit: BoxFit.cover,
                                              color: white,
                                              width: 20,
                                              height: 20,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 10, 0, 0),
                                      child: Text(
                                          style: const TextStyle(
                                              fontFamily: "yknir",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 25,
                                              color: white),
                                          snapshot.data!.followers.toString()),
                                      // tempFollowing.toString()),
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
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 0.0),
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
                                  Divider(
                                    color: grayL1.withOpacity(0.3),
                                  ),
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
                                      snapshot.data!.country),
                                  const SizedBox(height: 20),
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
                                          minimumSize:
                                              const Size.fromHeight(60),
                                          padding: const EdgeInsets.all(0),
                                          //////// HERE
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              MobileChatScreen.routeName,
                                              arguments: {
                                                'name': snapshot.data!.name,
                                                'uid': snapshot.data!.uid,
                                                'profilePic':
                                                    snapshot.data!.profilePic,
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 3),
                                                child: Text(
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: "yknir",
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 25,
                                                    ),
                                                    "Text Chat"),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                                color: white.withOpacity(0.2),
                                              ),
                                              height: 60,
                                              width: 80,
                                              child: Image(
                                                image:
                                                    Svg('assets/svg/chat.svg'),
                                                //fit: BoxFit.cover,
                                                color: white,
                                                width: 30,
                                                height: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(35, 0, 35, 0),
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pink,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          minimumSize:
                                              const Size.fromHeight(60),
                                          padding: const EdgeInsets.all(0),
                                          //////// HERE
                                        ),
                                        onPressed: () {
                                          makeCall(
                                              ref, context, widget.selectUser);
                                        },
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 3),
                                                child: Text(
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: "yknir",
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 25,
                                                    ),
                                                    "Video Call"),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0),
                                                ),
                                                color: white.withOpacity(0.2),
                                              ),
                                              height: 60,
                                              width: 80,
                                              child: Image(
                                                image: Svg(
                                                    'assets/svg/rvc_icon.svg'),
                                                //fit: BoxFit.cover,
                                                color: white,
                                                width: 32,
                                                height: 32,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }),
    );
    // }});
  }
}
