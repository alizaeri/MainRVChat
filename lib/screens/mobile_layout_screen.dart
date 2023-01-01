import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:rvchat/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/call/screens/call_pickup_screen.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/screens/followers_page.dart';
import 'package:rvchat/screens/online_user_screen.dart';
import 'package:rvchat/screens/random_video_chat.dart';
import 'package:rvchat/screens/test1.dart';
import 'package:rvchat/widgets/error.dart';
import '../features/chat/screen/contacts_screen.dart';
import 'profile_page.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    ref.read(authControllerProvider).setUserState(false);

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
        ref.read(authControllerProvider).setUserRandomState(false);
        break;
    }
  }

  int selectedPage = 2;

  @override
  Widget build(BuildContext context) {
    return CallPickupScreen(scaffold: scaffold());
  }

  final _pageNo = [
    const OnlineUsersScreen(),
    const FollowPage(),
    const RandomeVideoChat(),
    const ContactsScreen(),
    const ProfilePage(),
  ];

  Scaffold scaffold() {
    return Scaffold(
      key: _scaffoldKey,
      body: _pageNo[selectedPage],
      bottomNavigationBar: ConvexAppBar.badge(
        const {3: '99+'},
        items: [
          TabItem(
            icon: ImageIcon(const AssetImage("assets/icons/online.png"),
                color: white.withOpacity(0.5)),
            activeIcon: const ImageIcon(AssetImage("assets/icons/online.png"),
                color: pinkL1),
            title: "Online",
          ),
          TabItem(
              icon: ImageIcon(const AssetImage("assets/icons/fave.png"),
                  color: white.withOpacity(0.5)),
              activeIcon: const ImageIcon(AssetImage("assets/icons/fave.png"),
                  color: pinkL1),
              title: "Favorite"),
          TabItem(
              icon: ImageIcon(const AssetImage("assets/icons/rv.png"),
                  color: white.withOpacity(0.5)),
              activeIcon: const ImageIcon(AssetImage("assets/icons/rv.png"),
                  color: pinkL1),
              title: "RVChat"),
          TabItem(
              icon: ImageIcon(const AssetImage("assets/icons/chat.png"),
                  color: white.withOpacity(0.5)),
              activeIcon: const ImageIcon(AssetImage("assets/icons/chat.png"),
                  color: pinkL1),
              title: "Chat"),
          TabItem(
              icon: ImageIcon(const AssetImage("assets/icons/prof.png"),
                  color: white.withOpacity(0.5)),
              activeIcon: const ImageIcon(AssetImage("assets/icons/prof.png"),
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
  }
}
