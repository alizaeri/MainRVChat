import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:rvchat/add_helper.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/chat/controller/chat_controller.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';

import 'package:rvchat/models/chat_contact.dart';
import 'package:rvchat/models/user_model.dart';

class ContactsList extends ConsumerStatefulWidget {
  final String searchContact;
  const ContactsList(this.searchContact, {Key? key}) : super(key: key);
  @override
  ConsumerState<ContactsList> createState() => _ContactsListChatState();
}

class _ContactsListChatState extends ConsumerState<ContactsList>
    with WidgetsBindingObserver {
  BannerAd? _banner;
  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerListner,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderT();
          }
          return Column(
            children: [
              _banner == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 52,
                      child: AdWidget(ad: _banner!),
                    ),
              ListView.builder(
                shrinkWrap: true,
                padding: null,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  late ChatContact chatContactData;
                  if (widget.searchContact.isEmpty) {
                    chatContactData = snapshot.data![index];
                    return StreamBuilder<UserModel>(
                        stream: ref
                            .read(authControllerProvider)
                            .userDataById(chatContactData.contactId),
                        builder: (context, snapshot2) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MobileChatScreen.routeName,
                                        arguments: {
                                          'name': chatContactData.name,
                                          'uid': chatContactData.contactId,
                                          'profilePic':
                                              chatContactData.profilePic,
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
                                    leading: snapshot2.connectionState ==
                                            ConnectionState.waiting
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                grayL1.withOpacity(0.2),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                chatContactData.profilePic,
                                                // info[index]['profilePic'].toString(),
                                              ),
                                              backgroundColor: whiteW1,
                                              radius: 26,
                                            ),
                                          )
                                        : snapshot2.data!.isOnline
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundColor: pinkL2,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    chatContactData.profilePic,
                                                    // info[index]['profilePic'].toString(),
                                                  ),
                                                  radius: 26,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    grayL1.withOpacity(0.2),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    chatContactData.profilePic,
                                                    // info[index]['profilePic'].toString(),
                                                  ),
                                                  radius: 26,
                                                ),
                                              ),
                                    trailing: Text(
                                      DateFormat.Hm()
                                          .format(chatContactData.timeSent),
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
                        });
                  } else if (snapshot.data![index].name
                      .toLowerCase()
                      .contains(widget.searchContact.toLowerCase())) {
                    chatContactData = snapshot.data![index];
                    return StreamBuilder<UserModel>(
                        stream: ref
                            .read(authControllerProvider)
                            .userDataById(chatContactData.contactId),
                        builder: (context, snapshot2) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MobileChatScreen.routeName,
                                        arguments: {
                                          'name': chatContactData.name,
                                          'uid': chatContactData.contactId,
                                          'profilePic':
                                              chatContactData.profilePic,
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
                                    leading: snapshot2.connectionState ==
                                            ConnectionState.waiting
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                grayL1.withOpacity(0.2),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                chatContactData.profilePic,
                                                // info[index]['profilePic'].toString(),
                                              ),
                                              backgroundColor: whiteW1,
                                              radius: 26,
                                            ),
                                          )
                                        : snapshot2.data!.isOnline
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundColor: pinkL2,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    chatContactData.profilePic,
                                                    // info[index]['profilePic'].toString(),
                                                  ),
                                                  radius: 26,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    grayL1.withOpacity(0.2),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    chatContactData.profilePic,
                                                    // info[index]['profilePic'].toString(),
                                                  ),
                                                  radius: 26,
                                                ),
                                              ),
                                    trailing: Text(
                                      DateFormat.Hm()
                                          .format(chatContactData.timeSent),
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
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          );
        });
  }
}
