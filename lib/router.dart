import 'package:flutter/material.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';
import 'package:rvchat/features/auth/screens/otp_screen.dart';
import 'package:rvchat/features/auth/screens/user_information_screen.dart';
import 'package:rvchat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:rvchat/features/chat/screen/mobile_chat_screen.dart';
import 'package:rvchat/models/user_model.dart';
import 'package:rvchat/screens/profile_user_view.dart';
import 'package:rvchat/widgets/error.dart';

import 'screens/user_information_edit_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());

    case UserInformationEditPage.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationEditPage());
    case ProfileUserView.routeName:
      final argument = settings.arguments as Map<String, dynamic>;
      final UserModel user = argument['user'];
      final int following = argument['following'];
      final int followers = argument['followers'];
      // final user = settings.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => ProfileUserView(
                selectUser: user,
                following: following,
                followers: followers,
              ));
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactsScreen());
    case MobileChatScreen.routeName:
      final argument = settings.arguments as Map<String, dynamic>;
      final String name = argument['name'];
      final String uid = argument['uid'];

      final profilePic = argument['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                profilePic: profilePic,
              ));

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
