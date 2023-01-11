import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/Mycolors.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';

import 'package:rvchat/features/chat/widget/contacts_list.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchText = '';
  bool searchToggle = false;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    _controller.addListener(_onSearchChange);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_onSearchChange);
    _controller.dispose();
  }

  _onSearchChange() {
    // ignore: avoid_print
    print(_controller.text);
    setState(() {
      searchText = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: pinkL1,
          ),
    );
    return Scaffold(
      backgroundColor: const Color(0xff6c5dd2),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: pinkL1,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              "RVC Chat List",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "yknir",
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                searchToggle = !searchToggle;
              });
            },
            icon: Image(
              image: Svg('assets/svg/search.svg'),
              //fit: BoxFit.cover,
              color: white,
              width: 20,
              height: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: whiteW1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: searchToggle
                  ? TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText: 'Search Contact',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: pinkL1),
                          )),
                    )
                  : Container(),
            ),
            Expanded(
              child: ContactsList(searchText),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectContactsScreen.routeName);
        },
        backgroundColor: pinkL1,
        child: const Image(
          image: Svg('assets/svg/chat.svg'),
          //fit: BoxFit.cover,
          color: white,
          width: 25,
        ),
      ),
    );
  }
}
