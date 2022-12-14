import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';

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
              activeIcon: const ImageIcon(AssetImage("assets/icons/fave.png"),
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
