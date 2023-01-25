import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

final GoogleSignInProvider = Provider((ref) => GoogleSignInp());

class GoogleSignInp extends ChangeNotifier {
  final googlSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context, String country) async {
    GoogleSignInAccount? googleUser;
    try {
      try {
        googleUser = await googlSignIn.signIn();
      } catch (error) {
        print(error);
        return null;
      }

      if (googleUser == null) throw Exception("Not logged in");
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {}
        }
      }

      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
          context,
          UserInformationScreen.routeName,
          arguments: country,
          (route) => false);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: "Error, $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future googleLogOut(BuildContext context) async {
    GoogleSignInAccount? googleUser;

    try {
      await googlSignIn.signOut();
      await googlSignIn.disconnect();
    } catch (error) {
      print(error);
      return null;
    }

    notifyListeners();
  }
}
