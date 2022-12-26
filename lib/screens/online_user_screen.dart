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
      body: StreamBuilder(
          stream: getUsersStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            // if (snapshot.hasData) {
            List<UserModel> users = snapshot.data!;

            var size = MediaQuery.of(context).size;
            final double itemHeight = (size.height - kToolbarHeight - 10) / 3;
            final double itemWidth = size.width / 2;

            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              primary: false,
              shrinkWrap: true,
              children:
                  List<Widget>.generate(users.length, // same length as the data
                      (index) {
                return MyCard(
                  user: users[index],
                );
                //gridViewTile(recipesList, index);
              }),
            );
            // }
            // return const Center(child: Text("check your connection"));
          }),
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ProfileUserView.routeName,
          arguments: widget.user),
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
