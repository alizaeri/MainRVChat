import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/chat/widget/contacts_list.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchText = '';
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    _controller.addListener(_onSearchChange);
  }

  @override
  void dispose() {
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
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Contact',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue))),
              ),
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
