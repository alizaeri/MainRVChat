import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

class _RandomeVideoChatState extends ConsumerState<RandomeVideoChat> {
  bool rVChat = false;
  UserModel? selectRandomUser;

  @override
  void initState() {
    // ref.read(authControllerProvider).setUserRandomState(false);
    rVChat = true;

    ref.read(authControllerProvider).setUserRandomState(rVChat);

    // jabe ja shod

    super.initState();
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
    super.dispose();
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pic.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
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
                        "APPLY"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
