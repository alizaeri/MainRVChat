import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            image,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///---------
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
                          "Profile"),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  image == null
                                      ? const CircleAvatar(
                                          backgroundColor: white,
                                          radius: 75,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                              "assets/icons/avatar.png",
                                            ),
                                            radius: 70,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: white,
                                          radius: 75,
                                          child: CircleAvatar(
                                            backgroundImage: FileImage(
                                              image!,
                                            ),
                                            radius: 70,
                                          ),
                                        ),
                                  Positioned(
                                    top: 0,
                                    left: 110,
                                    child: CircleAvatar(
                                      backgroundColor: white.withOpacity(0.6),
                                      child: IconButton(
                                        onPressed: () {
                                          selectImage();
                                        },
                                        icon: const ImageIcon(
                                          AssetImage(
                                            "assets/icons/camera.png",
                                          ),
                                          color: pinkL1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "yknir",
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18,
                                        color: white),
                                    "Select a Profile Photo"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              color: white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: white,
                                width: 2,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: TextField(
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.next,
                              controller: nameController,
                              style: const TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  color: white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: white),
                                hintText: 'Enter Your Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: white),
                          "If you get Verification con from\n RVChat please inter and verify you cod"),
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
                //==> input text - Phone number

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: SizedBox(
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pinkL1,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          minimumSize: const Size.fromHeight(60)
                          //////// HERE
                          ),
                      onPressed: storeUserData,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //==> Enter phone number
                const Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: grayL1),
                    "If you get Verification con from\n RVChat please inter and verify you cod"),
                const SizedBox(height: 25),
                //==> CONTINUE Button
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
