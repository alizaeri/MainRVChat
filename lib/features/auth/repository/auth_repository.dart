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
  void signInWithPhone(BuildContext context, String phoneNumber) async {
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
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verficationID,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verficationID, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
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
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://pbs.twimg.com/profile_images/1419974913260232732/Cy_CUavB.jpg';
      if (profilePic != null) {
        photoUrl = await ref
            .read(CommonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.uid,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
