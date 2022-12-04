import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/common/widgets/custom_button.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty && country != null) {
      ref
          .read(authControllerProvider)
          .singInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: "Fill out all the feilds");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
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
                  Expanded(
                    child: Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/icons/avatar.png'),
                      ),
                    ),
                  ),
                  const Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: white),
                      "for read our polices please touch"),
                  const Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "yknir",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: yellow),
                      "RVChat Polices"),
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
                    SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                      ),
                      onPressed: pickCountry,
                      child: Image.asset(
                        "assets/icons/flag.png",
                        fit: BoxFit.cover,
                        scale: 8,
                      ),
                    ),
                    Image.asset(
                      "assets/icons/dropDownIcon.png",
                      fit: BoxFit.cover,
                      scale: 3,
                    ),
                    const SizedBox(width: 5),
                    if (country != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w300,
                                fontSize: 25,
                                color: grayL1.withOpacity(0.5)),
                            '+${country!.phoneCode}'),
                      ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: TextField(
                        controller: phoneController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            letterSpacing: 2,
                            color: grayL1),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          // for version 2 and greater youcan also use this
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '__________',
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //==> Enter phone number
            const Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "yknir",
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: grayL1),
                "Enter mobile number\n or Connect with a social media account"),
            const SizedBox(height: 20),
            //==> CONTINUE Button
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: SizedBox(
                child: ElevatedButton(
                  child: const Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                      "CONTINUE"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: pinkL1,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      minimumSize: const Size.fromHeight(60)
                      //////// HERE
                      ),
                  onPressed: () {
                    sendPhoneNumber();
                  },
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
                        child: Image.asset(
                          "assets/images/facebook.png",
                          fit: BoxFit.cover,
                          scale: 4,
                          color: pinkL1.withOpacity(0.5),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkL1.withOpacity(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side: BorderSide(
                                    color: pinkL1.withOpacity(0.5), width: 2)),
                            minimumSize: const Size.fromHeight(60)
                            //////// HERE
                            ),
                        onPressed: () {
                          sendPhoneNumber();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        child: Image.asset(
                          "assets/images/towitter.png",
                          fit: BoxFit.cover,
                          scale: 4,
                          color: pinkL1.withOpacity(0.5),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkL1.withOpacity(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side: BorderSide(
                                    color: pinkL1.withOpacity(0.5), width: 2)),
                            minimumSize: const Size.fromHeight(60)
                            //////// HERE
                            ),
                        onPressed: () {
                          sendPhoneNumber();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        child: Image.asset(
                          "assets/images/google.png",
                          fit: BoxFit.cover,
                          scale: 4,
                          color: pinkL1.withOpacity(0.5),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: pinkL1.withOpacity(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side: BorderSide(
                                    color: pinkL1.withOpacity(0.5), width: 2)),
                            minimumSize: const Size.fromHeight(60)
                            //////// HERE
                            ),
                        onPressed: () {
                          sendPhoneNumber();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    ); //height: size.height * 0.6,
  }
}
