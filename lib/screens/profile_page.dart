import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/user_information_edit_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderT();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///---------
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        //=> Background Linear Gradient
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [pinkL2, pinkL1, pinkL1]),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Text(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: "yknir",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 40,
                                  color: white),
                              snapshot.data!.name),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    UserInformationEditPage.routeName,
                                  );
                                },
                                icon: Image.asset(
                                  "assets/icons/edit.png",
                                  fit: BoxFit.cover,
                                  color: white,
                                  scale: 8,
                                ),
                              ),
                              const SizedBox(width: 20)
                            ],
                          ))
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      CircleAvatar(
                        backgroundColor: white,
                        radius: size.width * 0.21,
                        child: CircleAvatar(
                          backgroundImage: snapshot.data!.profilePic != null
                              ? NetworkImage(snapshot.data!.profilePic)
                              : const AssetImage(
                                  "assets/icons/avatar.png",
                                ) as ImageProvider,
                          radius: size.width * 0.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                          style: TextStyle(
                              fontFamily: "yknir",
                              fontWeight: FontWeight.w100,
                              fontSize: 40,
                              color: white),
                          "Alen Parish"),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/flow_icon.png",
                            fit: BoxFit.cover,
                            scale: 5,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                            child: Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: white),
                                "105k"),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Image.asset(
                            "assets/icons/like_icon.png",
                            fit: BoxFit.cover,
                            scale: 5,
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: Text(
                                style: TextStyle(
                                    fontFamily: "yknir",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                    color: white),
                                "25k"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/images/lineBg.png",
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: pinkL1),
                            "Full Name"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: 40,
                                color: grayL1),
                            "Alen Parish"),
                        Divider(),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: pinkL1),
                            "Country"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: 40,
                                color: grayL1),
                            "United State"),
                        Divider(),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: pinkL1),
                            "Phone Number"),
                        Text(
                            style: TextStyle(
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w100,
                                fontSize: 40,
                                color: grayL1),
                            "+16505555555"),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
