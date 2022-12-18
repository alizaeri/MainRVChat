import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:rvchat/models/call.dart';

import 'package:rvchat/screens/test1.dart';

import '../features/chat/screen/contacts_screen.dart';
import 'profile_page.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    ref.read(authControllerProvider).setUserState(true);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //didChangeAppLifecycleState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  int selectedPage = 2;

  final _pageNo = [
    const Favorite(),
    const Favorite(),
    const Favorite(),
    const ContactsScreen(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.call_end,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  channelId: call.callId,
                                  call: call,
                                  isGroupChat: false,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Scaffold(
          body: _pageNo[selectedPage],
          bottomNavigationBar: ConvexAppBar.badge(
            const {3: '99+'},
            items: [
              TabItem(
                icon: ImageIcon(const AssetImage("assets/icons/list.png"),
                    color: white.withOpacity(0.5)),
                activeIcon: const ImageIcon(AssetImage("assets/icons/list.png"),
                    color: pinkL1),
                title: "List",
              ),
              TabItem(
                  icon: ImageIcon(const AssetImage("assets/icons/fave.png"),
                      color: white.withOpacity(0.5)),
                  activeIcon: const ImageIcon(
                      AssetImage("assets/icons/fave.png"),
                      color: pinkL1),
                  title: "search"),
              TabItem(
                  icon: ImageIcon(const AssetImage("assets/icons/rv.png"),
                      color: white.withOpacity(0.5)),
                  activeIcon: const ImageIcon(AssetImage("assets/icons/rv.png"),
                      color: pinkL1),
                  title: "RVChat"),
              TabItem(
                  icon: ImageIcon(const AssetImage("assets/icons/chat.png"),
                      color: white.withOpacity(0.5)),
                  activeIcon: const ImageIcon(
                      AssetImage("assets/icons/chat.png"),
                      color: pinkL1),
                  title: "Chat"),
              TabItem(
                  icon: ImageIcon(const AssetImage("assets/icons/prof.png"),
                      color: white.withOpacity(0.5)),
                  activeIcon: const ImageIcon(
                      AssetImage("assets/icons/prof.png"),
                      color: pinkL1),
                  title: "Profile")
            ],
            backgroundColor: pinkL1,
            initialActiveIndex: selectedPage,
            onTap: (int index) {
              setState(() {
                selectedPage = index;
                print(selectedPage);
              });
            },
          ),
        );
      },
    );
  }
}
