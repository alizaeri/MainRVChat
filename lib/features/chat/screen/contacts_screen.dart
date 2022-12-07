import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/chat/widget/contacts_list.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 90,
          color: pinkL1,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "RVC Chat List",
                  style: TextStyle(
                      fontFamily: "yknir",
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: white),
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: pinkL1,
                      elevation: 0,
                      minimumSize: const Size.fromWidth(25),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {},
                  child: Image.asset(
                    "assets/icons/camera_icon.png",
                    fit: BoxFit.cover,
                    color: white,
                    scale: 7.5,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: pinkL1,
                    elevation: 0,
                    minimumSize: const Size.fromWidth(25),
                  ),
                  onPressed: () {},
                  child: Image.asset(
                    "assets/icons/search.png",
                    fit: BoxFit.cover,
                    color: white,
                    scale: 8,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: pinkL1,
                    minimumSize: const Size.fromWidth(25),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Stack(children: [
            Container(
              height: 30,
              color: pinkL1,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: whiteW1),
              ),
            ),
            const ContactsList()
          ]),
        ),
      ],
    ));
  }
}
