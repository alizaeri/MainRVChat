import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:rvchat/common/repositories/common_firebase_storage_repository.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/features/auth/screens/otp_screen.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/mobile_layout_screen.dart';

final AuthRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});
  void signInWithPhone(
      BuildContext context, String phoneNumber, String country) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            Fluttertoast.showToast(
                msg: "${e.message}",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);

            // throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? respondToken) async {
            Fluttertoast.showToast(
                msg: "verification code has been sent",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushNamed(context, OTPScreen.routeName, arguments: {
              'verificationId': verificationId,
              'country': country,
            }); // country ro beftestam inja
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: "Check your connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verficationID,
      required String userOTP,
      required String country}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verficationID, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context,
          UserInformationScreen.routeName,
          arguments: country,
          (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context,
      required defPic,
      required country,
      required firstEditPage}) async {
    try {
      String uid = auth.currentUser!.uid;
      bool exist = false;
      String photoUrl =
          'https://firebasestorage.googleapis.com/v0/b/mainrvchat.appspot.com/o/avatar.webp?alt=media&token=2688ba66-d18e-4089-b695-787a965b9312';
      if (profilePic != null) {
        photoUrl = await ref
            .read(CommonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      } else {
        photoUrl = defPic;
      }
      await firestore.collection('users').doc(uid).get().then((doc) {
        exist = doc.exists;
      });

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          rVChat: false,
          phoneNumber: auth.currentUser!.phoneNumber,
          following: 0,
          followers: 0,
          country: country,
          email: auth.currentUser!.email,
          isFake: false,
          coin: 0,
          lastOnlineTime: DateTime.now(),
          videoLink: '',
          groupId: []);
      if (!exist) {
        await firestore.collection('users').doc(uid).set(user.toMap());
      } else {
        firestore.collection('users').doc(uid).update({
          'name': name,
          'profilePic': photoUrl,
          'country': country,
        });
      }

      Navigator.pop(context);
      if (firstEditPage == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
            (route) => false);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Stream<List<UserModel>> allOnlineUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var document in event.docs) {
        if (document['isOnline'] == true) {
          print(
              'online find ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
          users.add(UserModel.fromMap(document.data()));
        } else {
          print(
              'online not find +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        }
      }

      return users;
    });
  }

  Stream<List<UserModel>> allLiveUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var document in event.docs) {
        if (document['rVChat'] == true) {
          users.add(UserModel.fromMap(document.data()));
        }
      }

      return users;
    });
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  void setUserRandomState(bool rVChat) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'rVChat': rVChat,
    });
  }
}
