import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:rvchat/features/chat/widget/contacts_list.dart';
import 'package:rvchat/screens/mobile_layout_screen.dart';
import 'package:rvchat/screens/test1.dart';

class MobileLayoutScreenMain extends ConsumerStatefulWidget {
  const MobileLayoutScreenMain({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreenMain> createState() =>
      _MobileLayoutScreenStateMain();
}

class _MobileLayoutScreenStateMain extends ConsumerState<MobileLayoutScreenMain>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    const ContactsList(),
    const Favorite()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: pinkL1,
        centerTitle: false,
        title: const Text(
          'RV Chat',
          style: TextStyle(
            fontSize: 20,
            color: white,
            fontFamily: "yknir",
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: white),
            onPressed: () {},
          ),
        ],
      ),
      body: _pageNo[selectedPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectContactsScreen.routeName);
        },
        backgroundColor: pinkL1,
        child: const ImageIcon(
          AssetImage(
            "assets/icons/contatMassage.png",
          ),
          color: white,
        ),
      ),
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
