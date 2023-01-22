import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';

final GoogleSignInProvider = Provider((ref) => GoogleSignInp());

class GoogleSignInp extends ChangeNotifier {
  final googlSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context, String country) async {
    final googleUser = await googlSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        arguments: country,
        (route) => false);
  }
}
