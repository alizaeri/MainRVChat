import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/chat/controller/chat_controller.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';

import 'package:rvchat/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderT();
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: null,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var chatContactData = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MobileChatScreen.routeName,
                            arguments: {
                              'name': chatContactData.name,
                              'uid': chatContactData.contactId,
                              'isGroupChat': true,
                              'profilePic': chatContactData.profilePic,
                            });
                      },
                      child: ListTile(
                        title: Text(
                          chatContactData.name,
                          //info[index]['name'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          chatContactData.lastMessage,
                          //info[index]['message'].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: pinkL2,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                              // info[index]['profilePic'].toString(),
                            ),
                            radius: 26,
                          ),
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactData.timeSent),
                          //info[index]['time'].toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 0),
                  ],
                ),
              );
            },
          );
        });
  }
}
