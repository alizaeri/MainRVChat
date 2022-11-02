import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);
  static const String routeName = '/otp-screen';
  final String verificationId;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verfiyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("We have sent an SMS with the code"),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(fontSize: 30),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    print("verfing otp");
                    verifyOTP(ref, context, val.trim());
                  }
                  print("this function was run");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
