import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rvchat/common/widgets/custom_button.dart';
import 'package:rvchat/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);
  void navigationToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Welcome to RVChat",
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 500,
          ),
          SizedBox(
            child: CustomButton(
              text: "AGREE AND CONTINUE",
              onPressed: () => navigationToLoginScreen(context),
            ),
          ),
        ],
      )),
    );
  }
}
