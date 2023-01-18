import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/utils/utils.dart';

import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/auth/screens/verify_email_page.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();

  Country? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  bool emailVerification = true;

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          emailVerification, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  bool fisClick = false;
  final formKey = GlobalKey<FormState>();

  void sendPhoneNumber(String countryName) {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty && country != null) {
      ref.read(authControllerProvider).singInWithPhone(
          context, '+${country!.phoneCode}$phoneNumber', countryName);
    } else {
      showSnackBar(context: context, content: "Fill out all the feilds");
      fisClick = false;
    }
  }

  Future signInWithEmailandLink(String countryName) async {
    String _userEmail = emailController.text.trim();
    return await FirebaseAuth.instance
        .sendSignInLinkToEmail(
            email: _userEmail,
            actionCodeSettings: ActionCodeSettings(
              url: "https://appeksgrupp.page.link/muUh",
              handleCodeInApp: true,
              androidPackageName: "mainrvchat.appspot.com",
              androidMinimumVersion: "1",
            ))
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyEmailPage(
                  country: countryName,
                )),
      );
      print("email sent");
    });
  }

  Future signUp(String countryName) async {
    // final isValid = formKey.currentState!.validate();
    if (false) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: '123456789', //passwordController.text.trim(),
      );
      print(
          'sigh up suxseed 44444444444444444444444444444444444444444444444444444444444444444444444444444444444444');
    } on FirebaseAuthException catch (e) {
      print(e);

      // Utils.showSnackBar(e.message);
    }
    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyEmailPage(
                country: countryName,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            //=> Background Linear Gradient
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [pinkL2, pinkL1, pinkL1]),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          const Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 40,
                                  color: white),
                              "Login"),
                          const Expanded(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: white,
                                radius: 75,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/images/avatar.webp",
                                  ),
                                  radius: 70,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: white),
                                  "Random Video Chat "),
                              Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "yknir",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: yellow),
                                  "RVChat"),
                            ],
                          ),
                          const Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: white),
                              "Find Your Partner"),
                          Image.asset(
                            "assets/images/lineBg.png",
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(children: [
                    //----------------
                    const SizedBox(height: 15),
                    //==> Get Start with RVChat
                    const Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: grayL1),
                        "Get start with RVChat"),
                    const SizedBox(height: 15),
                    //==> input text - Phone number
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: pinkL1.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: pinkL1,
                              width: 2,
                            )),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              onPressed: pickCountry,
                              child: country != null
                                  ? Text(
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                      country!.flagEmoji,
                                    )
                                  : Image.asset(
                                      "assets/icons/flag.png",
                                      fit: BoxFit.cover,
                                      scale: 8,
                                    ),
                            ),
                            const Image(
                              image: Svg('assets/svg/drop_down_icon.svg'),
                              //fit: BoxFit.cover,
                              color: grayL1,
                              width: 6,
                              height: 6,
                            ),
                            const SizedBox(width: 5),
                            if (country != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: emailVerification
                                    ? Text(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "yknir",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 25,
                                            color: grayL1.withOpacity(0.5)),
                                        '+${country!.phoneCode}')
                                    : null,
                              ),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Center(
                              child: emailVerification
                                  ? TextField(
                                      controller: phoneController,
                                      textAlign: TextAlign.left,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          fontFamily: "yknir",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 25,
                                          letterSpacing: 5,
                                          color: grayL1),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        // for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Your phone number]',
                                        hintStyle: TextStyle(
                                            color: grayL1.withOpacity(0.2)),
                                      ),
                                    )
                                  : TextField(
                                      controller: emailController,
                                      textAlign: TextAlign.left,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          fontFamily: "yknir",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: grayL1),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Your E-mail',
                                        hintStyle: TextStyle(
                                            color: grayL1.withOpacity(0.2)),
                                      ),
                                    ),
                            )),
                            // emailVerification
                            //     ? TextField(
                            //         controller: passwordController,
                            //         textAlign: TextAlign.left,
                            //         textInputAction: TextInputAction.next,
                            //         style: const TextStyle(
                            //             fontFamily: "yknir",
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 14,
                            //             letterSpacing: 2,
                            //             color: grayL1),
                            //         keyboardType: TextInputType.text,
                            //         decoration: const InputDecoration(
                            //           border: InputBorder.none,
                            //           hintText: '__________',
                            //         ),
                            //       )
                            //     : Container(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //==> Enter phone number
                    emailVerification
                        ? const Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: grayL1),
                            "Enter mobile number or\nConnect with a social media account")
                        : const Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: grayL1),
                            "Enter email address or\nConnect with a social media account"),
                    const SizedBox(height: 20),
                    //==> CONTINUE Button
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
                          onPressed: () {
                            if (emailVerification) {
                              sendPhoneNumber(country!.name);
                            } else {
                              signInWithEmailandLink(country!.name);
                            }

                            setState(() {
                              // fisClick = true;
                            });
                          },
                          child: const Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                              "CONTINUE"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 35, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: pinkL1.withOpacity(0),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: BorderSide(
                                            color: pinkL1.withOpacity(0.5),
                                            width: 2)),
                                    minimumSize: const Size.fromHeight(60)
                                    //////// HERE
                                    ),
                                onPressed: () {},
                                child: Image.asset(
                                  "assets/images/facebook.png",
                                  fit: BoxFit.cover,
                                  scale: 4,
                                  color: pinkL1.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: pinkL1.withOpacity(0),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: BorderSide(
                                            color: pinkL1.withOpacity(0.5),
                                            width: 2)),
                                    minimumSize: const Size.fromHeight(60)
                                    //////// HERE
                                    ),
                                onPressed: () {},
                                child: Image.asset(
                                  "assets/images/google.png",
                                  fit: BoxFit.cover,
                                  scale: 4,
                                  color: pinkL1.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: pinkL1,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        side: BorderSide(
                                            color: pinkL1.withOpacity(0.5),
                                            width: 2)),
                                    minimumSize: const Size.fromHeight(60)
                                    //////// HERE
                                    ),
                                onPressed: () {
                                  setState(() {
                                    emailVerification = !emailVerification;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                child: emailVerification
                                    ? Image(
                                        image: Svg('assets/svg/email_b.svg'),
                                        //fit: BoxFit.cover,
                                        color: whiteW1,
                                        width: 30,
                                        height: 30,
                                      )
                                    : Image(
                                        image: Svg('assets/svg/phone.svg'),
                                        //fit: BoxFit.cover,
                                        color: whiteW1,
                                        width: 35,
                                        height: 35,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
          fisClick ? const Loader() : const Center(),
        ],
      ),
    ); //height: size.height * 0.6,
  }
}
