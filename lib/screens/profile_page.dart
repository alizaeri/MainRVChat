import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rvchat/add_helper.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/user_information_edit_page.dart';

import '../common/widgets/loaderT.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  RewardedAd? _rewardedAd;
  int currentCoin = 2;

  @override
  void initState() {
    super.initState();
    _createRewardAd();
  }

  void _createRewardAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => _rewardedAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _rewardedAd = null),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardAd();
      });
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
        currentCoin = currentCoin + 2;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'coin': currentCoin,
        });
      });
      _rewardedAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            currentCoin = snapshot.data!.coin;
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
                      SizedBox(height: size.height * 0.005),
                      CircleAvatar(
                        backgroundColor: white,
                        radius: size.width * 0.19,
                        child: CircleAvatar(
                          backgroundImage: snapshot.data!.profilePic == null
                              ? const AssetImage("assets/images/avatar.webp")
                                  as ImageProvider
                              : NetworkImage(snapshot.data!.profilePic),
                          radius: size.width * 0.18,
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
                          const SizedBox(
                            width: 40,
                          ),
                          const Image(
                            image: Svg('assets/svg/coin.svg'),
                            fit: BoxFit.cover,
                            color: yellow,
                            width: 22,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: white),
                                snapshot.data!.coin.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellow,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            minimumSize: const Size.fromHeight(60),
                            padding: const EdgeInsets.all(0),
                            //////// HERE
                          ),
                          onPressed: () async {
                            _showRewardedAd();
                          },
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25,
                                      color: white,
                                    ),
                                    "Get Coin"),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  color: pink.withOpacity(0.5),
                                ),
                                height: 60,
                                width: 80,
                                child: const Image(
                                  image: Svg('assets/svg/coins.svg'),
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
                                fontSize: size.width * 0.07,
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
                                fontSize: size.width * 0.07,
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
                        snapshot.data!.phoneNumber == null
                            ? Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w100,
                                    fontSize: size.width * 0.07,
                                    color: grayL1),
                                '')
                            : Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w100,
                                    fontSize: size.width * 0.07,
                                    color: grayL1),
                                snapshot.data!.phoneNumber!),
                        Divider(color: grayL1.withOpacity(0.5)),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: size.width * 0.035,
                                color: pinkL1),
                            "Email Address"),
                        snapshot.data!.email == null
                            ? Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w100,
                                    fontSize: size.width * 0.06,
                                    color: grayL1),
                                '')
                            : Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w100,
                                    fontSize: size.width * 0.06,
                                    color: grayL1),
                                snapshot.data!.email!),
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
