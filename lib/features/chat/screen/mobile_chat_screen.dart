import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/features/call/screens/call_pickup_screen.dart';
import 'package:rvchat/features/chat/widget/bottom-chat-field.dart';
import 'package:rvchat/features/chat/widget/chat_list.dart';

import 'package:rvchat/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;

  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) {
    bool isGroup = false;
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroup,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        backgroundColor: const Color(0xff6c5dd2),
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: pinkL1,
          leading: IconButton(
              onPressed: () => makeCall(ref, context),
              icon: Image.asset(
                "assets/icons/back_icon.png",
                fit: BoxFit.cover,
                color: white,
                scale: 7,
              )),
          title: StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).userDataById(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoaderT();
                }
                return Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: "yknir",
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    snapshot.data!.isOnline
                        ? const Text(
                            'online',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                color: yellow),
                          )
                        : Text('offline',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "yknir",
                                fontWeight: FontWeight.w400,
                                color: whiteW1.withOpacity(0.5))),
                  ],
                );
              }),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () => makeCall(ref, context),
                icon: Image.asset(
                  "assets/icons/rv.png",
                  fit: BoxFit.cover,
                  color: white,
                  scale: 5.5,
                )),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/icons/call.png",
                fit: BoxFit.cover,
                color: white,
                scale: 8,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                whiteW1.withOpacity(0.7),
                whiteW1.withOpacity(0.9),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: ChatList(
                    recieverUserId: uid,
                  ),
                ),
              ),
              BottomChatField(
                recieverUserId: uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
