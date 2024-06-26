import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rvchat/add_helper.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/profile_user_view.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  List<UserModel> onlineList = [];
  List<UserModel> man = [];
  bool online_null = false;
  BannerAd? _banner;

  @override
  void initState() {
    getfollowingUser();

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

  Stream<List<UserModel>> getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      List<UserModel> allUser = [];

      for (var document in event.docs) {
        if (document['isOnline'] == true) {
          allUser.add(UserModel.fromMap(document.data()));
        }
      }

      return allUser;
    });
  }

  Stream<List<UserModel>> getfollowingUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following')
        .snapshots()
        .map((event) {
      List<UserModel> followingList = [];
      for (var doc in event.docs) {
        followingList.add(UserModel.fromMap(doc.data()));
        print(doc['uid']);
      }

      return followingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
              "My Favorite",
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
      body: StreamBuilder<List<UserModel>>(
        stream: getfollowingUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderT();
          }
          List<UserModel> users = snapshot.data!;
          users.removeWhere(
              (item) => item.uid == FirebaseAuth.instance.currentUser!.uid);
          var size = MediaQuery.of(context).size;
          final double itemHeight =
              (size.width - kToolbarHeight - 10) / 3; /////////////
          final double itemWidth = size.width / 3;
          if (users.isNotEmpty) {
            return Column(
              children: [
                StreamBuilder<List<UserModel>>(
                  stream: getUsersStream(),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
                      return const LoaderT();
                    }
                    List<UserModel> usersOnlines = snapshot2.data!;
                    List<UserModel> finallist = [];
                    for (var document in usersOnlines) {
                      for (var item in users) {
                        if (document.uid == item.uid && item.isOnline == true) {
                          finallist.add(document);
                        }
                      }
                    }
                    return finallist.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 90,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(left: 10),
                                scrollDirection: Axis.horizontal,
                                itemCount: finallist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 0, 5.0, 5.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor: white,
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                finallist[index].profilePic),
                                          ),
                                        ),
                                        Text(
                                          finallist[index].name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: whiteW1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: Column(
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
                          GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: ((itemWidth / 2) / itemHeight),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: size.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: whiteW1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [Text('there is no favorite user')],
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
            height: size.width / 2.35,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              image: DecorationImage(
                  image: NetworkImage(
                    widget.user.profilePic,
                    // info[index]['profilePic'].toString(),
                  ),
                  fit: BoxFit.cover),
            ),
            child: Column(
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
                          radius: 10,
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
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: white),
                              widget.user.following.toString()),
                        ),
                        Expanded(flex: 2, child: Container()),
                        CircleAvatar(
                          backgroundColor: white.withOpacity(0.3),
                          radius: 10,
                          child: Image(
                            image: Svg('assets/svg/heart_b.svg'),
                            fit: BoxFit.cover,
                            color: white,
                            width: 12,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
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
            ), // Use the fullName property of each item
          ),
          const SizedBox(height: 5),
          Text(
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "yknir",
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: grayL1),
            widget.user.name,
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
