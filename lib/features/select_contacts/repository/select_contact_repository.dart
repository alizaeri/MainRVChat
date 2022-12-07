import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});
  getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        // print(selectContact.phones[0].number);
        String selectedPhoneNum = selectContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        print(selectedPhoneNum);
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          print(userData.name);
          print(userData.uid);
          print(FirebaseAuth.instance.currentUser!.uid);

          await Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {
                'name': userData.name,
                'uid': userData.uid,
                'profilePic': userData.profilePic
              });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: 'This number does not exit on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
