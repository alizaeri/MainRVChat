import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/features/select_contacts/controller/select_contact_controller.dart';
import 'package:rvchat/widgets/error.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactContollerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xff6c5dd2),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: pinkL1,
        leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/back_icon.png",
              fit: BoxFit.cover,
              color: white,
              scale: 7,
            )),
        title: Row(
          children: const [
            SizedBox(
              width: 15,
            ),
            Text(
              "RVC Select Contact",
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
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: whiteW1),
              child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () => selectContact(ref, contact, context),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  radius: 32,
                                  backgroundColor: grayL1,
                                  child: CircleAvatar(
                                    radius: 31,
                                    backgroundColor: white,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.photo!),
                                      radius: 30,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
