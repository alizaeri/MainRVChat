import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:rvchat/models/call.dart';
import 'package:rvchat/screens/blocked.dart';
import 'package:rvchat/screens/busy.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    bool exist = false;
    bool blocked = false;
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .get()
          .then((doc) {
        exist = doc.exists;
      });
      await firestore
          .collection('users')
          .doc(senderCallData.receiverId)
          .collection('block')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) {
        blocked = doc.exists;
      });

      if (exist) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Busy(),
          ),
        );
        return;
      } else if (blocked) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Blocked(),
          ),
        );
        return;
      } else {
        await firestore
            .collection('call')
            .doc(senderCallData.callerId)
            .set(senderCallData.toMap());
        await firestore
            .collection('call')
            .doc(senderCallData.receiverId)
            .set(receiverCallData.toMap());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (Context) => CallScreen(
              channelId: senderCallData.callId,
              call: senderCallData,
              isGroupChat: false,
            ),
          ),
        );
      }
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  // void makeGroupCall(
  //   Call senderCallData,
  //   BuildContext context,
  //   Call receiverCallData,
  // ) async {
  //   try {
  //     await firestore
  //         .collection('call')
  //         .doc(senderCallData.callerId)
  //         .set(senderCallData.toMap());

  //     var groupSnapshot = await firestore
  //         .collection('groups')
  //         .doc(senderCallData.receiverId)
  //         .get();
  //     model.Group group = model.Group.fromMap(groupSnapshot.data()!);

  //     for (var id in group.membersUid) {
  //       await firestore
  //           .collection('call')
  //           .doc(id)
  //           .set(receiverCallData.toMap());
  //     }

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CallScreen(
  //           channelId: senderCallData.callId,
  //           call: senderCallData,
  //           isGroupChat: true,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // void endGroupCall(
  //   String callerId,
  //   String receiverId,
  //   BuildContext context,
  // ) async {
  //   try {
  //     await firestore.collection('call').doc(callerId).delete();
  //     var groupSnapshot =
  //         await firestore.collection('groups').doc(receiverId).get();
  //     model.Group group = model.Group.fromMap(groupSnapshot.data()!);
  //     for (var id in group.membersUid) {
  //       await firestore.collection('call').doc(id).delete();
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }
}
