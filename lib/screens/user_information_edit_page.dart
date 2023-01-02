import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/models/user_model.dart';

class UserInformationEditPage extends ConsumerStatefulWidget {
  static const String routeName = '/user-information-edit';
  final String country;
  const UserInformationEditPage({Key? key, required this.country})
      : super(key: key);

  @override
  ConsumerState<UserInformationEditPage> createState() =>
      _UserInformationEditPageState();
}

class _UserInformationEditPageState
    extends ConsumerState<UserInformationEditPage> {
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

  void storeUserData(String defName, String defPic) async {
    String name = nameController.text.trim();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoaderT(),
    //   ),
    // );
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => LoaderT(),
      ),
    );

    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
          context, name, image, defPic, widget.country, false);
    } else {
      ref.read(authControllerProvider).saveUserDataToFirebase(
          context, defName, image, defPic, widget.country, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool fisClick = false;
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
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
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: IconButton(
                                          onPressed: () {
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            } else {
                                              SystemNavigator.pop();
                                            }
                                          },
                                          icon: Image.asset(
                                            "assets/icons/back_icon.png",
                                            fit: BoxFit.cover,
                                            color: white,
                                            scale: 5,
                                          )),
                                    ),
                                    Expanded(child: Container()),
                                    const Text(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "yknir",
                                            fontWeight: FontWeight.w800,
                                            fontSize: 40,
                                            color: white),
                                        "Profile"),
                                    Expanded(child: Container()),
                                    const SizedBox(width: 50)
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            image == null
                                                ? CircleAvatar(
                                                    backgroundColor: white,
                                                    radius: 75,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(snapshot
                                                              .data!
                                                              .profilePic),
                                                      //     AssetImage(
                                                      //   "assets/icons/avatar.png",
                                                      // ),
                                                      radius: 70,
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor: white,
                                                    radius: 75,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          FileImage(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 35, 0),
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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle:
                                              const TextStyle(color: white),
                                          hintText: snapshot.data!.name,
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
                                    "Shange your name"),
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
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    minimumSize: const Size.fromHeight(60)
                                    //////// HERE
                                    ),
                                onPressed: () {
                                  storeUserData(snapshot.data!.name,
                                      snapshot.data!.profilePic);
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
                              "Save to your profile"),
                          const SizedBox(height: 25),
                          //==> CONTINUE Button
                        ]),
                      ],
                    ),
                  ),
                ),
                fisClick ? const LoaderT() : const Center(),
              ],
            );
          }),
    );
  }
}
