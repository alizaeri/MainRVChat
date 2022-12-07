import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);
  static const String routeName = '/otp-screen';
  final String verificationId;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    //bool fisClick = false;
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
                              "Verfing OTP"),
                          Expanded(
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/icons/avatar.png",
                                  fit: BoxFit.cover,
                                  scale: (size.width / size.width) * 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: TextField(
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                                letterSpacing: 10,
                                color: grayL1),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              // for below version 2 use this
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              // for version 2 and greater youcan also use this
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '_______',
                            ),
                            onChanged: (val) {
                              if (val.length == 6) {
                                print("verfing otp");
                                verifyOTP(ref, context, val.trim());
                              }
                              print("this function was run");
                            },
                          ),
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
                        "Enter mobile number or\nConnect with a social media account"),
                    const SizedBox(height: 20),
                    //==> CONTINUE Button
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
