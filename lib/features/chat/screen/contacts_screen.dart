import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/chat/widget/contacts_list.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/search.png",
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
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: whiteW1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Expanded(child: ContactsList()),
          ],
        ),
      ),
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
    );
  }
}
