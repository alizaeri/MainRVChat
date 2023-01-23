import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rvchat/add_helper.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/profile_user_view.dart';

class OnlineUsersScreen extends StatefulWidget {
  const OnlineUsersScreen({super.key});

  @override
  State<OnlineUsersScreen> createState() => _OnlineUsersScreenState();
}

class _OnlineUsersScreenState extends State<OnlineUsersScreen> {
  BannerAd? _banner;
  Stream<List<UserModel>> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var document in event.docs) {
        if (document['isOnline'] == true) {
          users.add(UserModel.fromMap(document.data()));
        }
      }
      return users;
    });
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerListner,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6c5dd2),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: pinkL1,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              "People Online",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "yknir",
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: whiteW1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _banner == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 50,
                      child: AdWidget(ad: _banner!),
                    ),
                  ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                    stream: getUsersStream(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoaderT();
                      }
                      // if (snapshot.hasData) {
                      List<UserModel> users = snapshot.data;
                      users.removeWhere((item) =>
                          item.uid == FirebaseAuth.instance.currentUser!.uid);
                      var size = MediaQuery.of(context).size;
                      final double itemHeight =
                          (size.height - kToolbarHeight - 10) / 3;
                      final double itemWidth = size.width / 2;
                      if (users.isNotEmpty) {
                        return GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          children: List<Widget>.generate(
                              users.length, // same length as the data
                              (index) {
                            return MyCard(
                              user: users[index],
                            );

                            //gridViewTile(recipesList, index);
                          }),
                        );
                      } else {
                        return const Center(
                          child: Text('there is no user online'),
                        );
                      }

                      // }
                      // return const Center(child: Text("check your connection"));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCard extends StatefulWidget {
  final UserModel user;
  const MyCard({super.key, required this.user});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  int following = 0;
  int followers = 0;
  void calculateFollow() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('followers')
        .get();

    following = querySnapshot.docs.length;
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('following')
        .get();
    followers = querySnapshot2.docs.length;
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, ProfileUserView.routeName, arguments: {
      'user': widget.user,
      'following': following,
      'followers': followers,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        calculateFollow();
      },
      child: Column(
        children: [
          Container(
            width: (size.width / 3),
            height: (size.width / 3),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              image: DecorationImage(
                  image: NetworkImage(
                    widget.user.profilePic,
                    // info[index]['profilePic'].toString(),
                  ),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        gradient: LinearGradient(
                            //=> Background Linear Gradient
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [grayL1.withOpacity(0), grayL1]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: white.withOpacity(0.3),
                              radius: 12,
                              child: const Image(
                                image: Svg('assets/svg/flow_icon.svg'),
                                //fit: BoxFit.cover,
                                color: white,
                                width: 13,
                                height: 13,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: white),
                                  widget.user.following.toString()),
                            ),
                            Expanded(child: Container()),
                            CircleAvatar(
                              backgroundColor: white.withOpacity(0.3),
                              radius: 12,
                              child: const Image(
                                image: Svg('assets/svg/heart_b.svg'),
                                fit: BoxFit.cover,
                                color: white,
                                width: 12,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: white),
                                  widget.user.followers.toString()),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Positioned(
                    left: 8,
                    top: 5,
                    child: Text(
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: pink),
                        "Live"))
              ],
            ), // Use the fullName property of each item
          ),
          SizedBox(height: 5),
          Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "yknir",
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: grayL1),
              widget.user.name),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
