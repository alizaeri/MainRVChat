import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  final String country;
  const VerifyEmailPage({Key? key, required this.country}) : super(key: key);
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with WidgetsBindingObserver {
  bool isEmailVerified = false;
  bool canResendEmail = false;

  Timer? timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // // isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    // final signInMethods = await FirebaseAuth.instance
    //     .fetchSignInMethodsForEmail('Alizaery@yahoo.com');
    // final userExists = signInMethods.isNotEmpty;
    // final canSignInWithLink =
    //     signInMethods.contains(EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD);
    // final canSignInWithPassword =
    //     signInMethods.contains(EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD);
    // if (!isEmailVerified) {
    //   // sendVerificationEmail();
    //   timer = Timer.periodic(
    //     Duration(seconds: 3),
    //     (_) => () {}, // checkEmailVerified(),
    //   );
    // }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  Future<void> _retrieveDynamicLink() async {
    if (FirebaseAuth.instance
        .isSignInWithEmailLink("https://appeksgrupp.page.link/muUh")) {
      try {
        // The client SDK will parse the code from the link for you.
        final userCredential = await FirebaseAuth.instance.signInWithEmailLink(
            email: 'zaeriali110@gmail.com',
            emailLink: "https://appeksgrupp.page.link/muUh");

        // You can access the new user via userCredential.user.
        final emailAddress = userCredential.user?.email;
        setState(() {
          isEmailVerified = true;
        });
        isEmailVerified = true;

        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link.');
      }
    }
  }

  // Future checkEmailVerified() async {
  //   await FirebaseAuth.instance.currentUser!.reload();
  //   setState(() {
  //     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //   });
  //   if (isEmailVerified) {
  //     timer?.cancel();
  //   }
  // }

  // Future sendVerificationEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //     setState(() => canResendEmail = false);
  //     await Future.delayed(Duration(seconds: 5));
  //     setState(() => canResendEmail = true);
  //   } catch (e) {}
  // }

  Widget build(BuildContext context) => isEmailVerified
      ? UserInformationScreen(
          country: widget.country,
        )
      : Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 189, 185, 233),
                  Color.fromARGB(255, 215, 215, 233),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Verify Email',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "seguiB",
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'a verfication email has been sent to your email',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "seguiM",
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: canResendEmail ? null : null,
                      child: const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Resent Email",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "seguiB"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xffffffff),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(color: Colors.blue)),
                        ),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontFamily: "seguiB"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
