import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      print(users);

      return users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
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
        .collection('following')
        .get();

    following = querySnapshot.docs.length;
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('followers')
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
          SizedBox(height: 10),
          const Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "yknir",
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: grayL1),
              "Elena Johanson"),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
