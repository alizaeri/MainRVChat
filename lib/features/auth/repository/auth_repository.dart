import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? respondToken) async {
            Navigator.pushNamed(context, OTPScreen.routeName, arguments: {
              'verificationId': verificationId,
              'country': country,
            }); // country ro beftestam inja
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
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
      required country}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://firebasestorage.googleapis.com/v0/b/mainrvchat.appspot.com/o/avatar.png?alt=media&token=6ac19ca3-c79d-4d64-9ee0-53c673440cbc';
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
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          rVChat: false,
          phoneNumber: auth.currentUser!.phoneNumber!,
          following: 0,
          followers: 0,
          country: country,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
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
        if (document['rVChat'] == true) {
          print('online find ++++++++++++++');
          users.add(UserModel.fromMap(document.data()));
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
