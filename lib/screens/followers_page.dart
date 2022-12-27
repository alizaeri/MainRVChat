import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  List<UserModel> onlineUser = [];
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
      }
      for (var user in followingList) {
        if (user.isOnline == true) {
          onlineUser.add(user);
        }
      }
      return followingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          final double itemHeight = (size.height - kToolbarHeight - 10) / 3;
          final double itemWidth = size.width / 2;

          if (users.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50,
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: onlineUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                      onlineUser[index].profilePic),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  onlineUser[index].name,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
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
            );
          } else {
            return const Center(
              child: Text('there is no favorite user'),
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
    return GestureDetector(
      onTap: () {
        calculateFollow();
      },
      child: Container(
        color: const Color.fromARGB(255, 239, 127, 107),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: pinkL2,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.user.profilePic,
                      // info[index]['profilePic'].toString(),
                    ),
                    radius: 70,
                  ),
                )),
            Text(
              widget.user.name,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          // pressAttention = !pressAttention;
                          // widget._deleteDoc(recipe: widget.recipe);

                          /*
                          widget._saveRecipeToUserSubcollection(
                              recipe: widget.recipe);
                              */
                        });
                      },
                      icon: const Icon(Icons.abc

                          //Color.fromARGB(255, 239, 61, 100),
                          ),
                    ),
                  ),
                )
              ],
            )
          ],
        ), // Use the fullName property of each item
      ),
    );
  }
}
