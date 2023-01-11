import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
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
  void dispose() async {
    super.dispose();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'isOnline': false,
      });
    } catch (e) {
      print('user sign out befor $e');
    }

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
            icon: Image(
              image: const Svg('assets/svg/online.svg'),
              //fit: BoxFit.cover,
              color: white.withOpacity(0.5),
              width: 20,
              height: 20,
            ),
            activeIcon: const Image(
              image: Svg('assets/svg/online.svg'),
              //fit: BoxFit.cover,
              color: pinkL1,
              width: 40,
              height: 40,
            ),
            title: "Online",
          ),
          TabItem(
              icon: Image(
                image: const Svg('assets/svg/home.svg'),
                //fit: BoxFit.cover,
                color: white.withOpacity(0.5),
                width: 20,
                height: 20,
              ),
              activeIcon: const Image(
                image: Svg('assets/svg/home.svg'),
                //fit: BoxFit.cover,
                color: pinkL1,
                width: 40,
                height: 40,
              ),
              title: "Favorite"),
          TabItem(
              icon: Image(
                image: const Svg('assets/svg/rvc_icon.svg'),
                //fit: BoxFit.cover,
                color: white.withOpacity(0.5),
                width: 22,
                height: 22,
              ),
              activeIcon: const Image(
                image: Svg('assets/svg/rvc_icon.svg'),
                //fit: BoxFit.cover,
                color: pinkL1,
                width: 40,
                height: 40,
              ),
              title: "RVChat"),
          TabItem(
              icon: Image(
                image: const Svg('assets/svg/chat.svg'),
                //fit: BoxFit.cover,
                color: white.withOpacity(0.5),
                width: 20,
                height: 20,
              ),
              activeIcon: const Image(
                image: Svg('assets/svg/chat.svg'),
                //fit: BoxFit.cover,
                color: pinkL1,
                width: 40,
                height: 40,
              ),
              title: "Chat"),
          TabItem(
              icon: Image(
                image: const Svg('assets/svg/prof.svg'),
                //fit: BoxFit.cover,
                color: white.withOpacity(0.5),
                width: 20,
                height: 20,
              ),
              activeIcon: const Image(
                image: Svg('assets/svg/prof.svg'),
                //fit: BoxFit.cover,
                color: pinkL1,
                width: 40,
                height: 40,
              ),
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
