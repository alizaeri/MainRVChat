import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  final String country;
  const UserInformationScreen({Key? key, required this.country})
      : super(key: key);

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
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => LoaderT(),
      ),
    );
    String name = nameController.text.trim();
    String defPic =
        'https://firebasestorage.googleapis.com/v0/b/mainrvchat.appspot.com/o/avatar.png?alt=media&token=8f42e74c-ac50-453e-9731-c51a1a4b0f4f';
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
          context, name, image, defPic, widget.country, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool fisClick = false;
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
                                                  "assets/images/avatar.webp",
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
                                          backgroundColor:
                                              white.withOpacity(0.6),
                                          child: IconButton(
                                            onPressed: () {
                                              selectImage();
                                            },
                                            icon: const Image(
                                              image: Svg(
                                                  'assets/svg/cam_edit.svg'),
                                              fit: BoxFit.cover,
                                              color: pinkL1,
                                              width: 23,
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

                    const SizedBox(height: 20),
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
                            storeUserData();
                            setState(() {
                              fisClick = true;
                            });
                          },
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
                        "If you get Verification con from\n RVChat please inter and verify you cod"),
                    const SizedBox(height: 25),
                    //==> CONTINUE Button
                  ]),
                ],
              ),
            ),
          ),
          fisClick ? const Loader() : const Center(),
        ],
      ),
    );
  }
}
