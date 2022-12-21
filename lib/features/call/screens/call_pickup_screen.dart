import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_call.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: white,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 90,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontFamily: "yknir",
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: pink,
                          child: IconButton(
                            onPressed: () {
                              ref.read(callControllerProvider).endCall(
                                    call.callerId,
                                    call.receiverId,
                                    context,
                                  );
                            },
                            icon: Image.asset(
                              "assets/icons/endcall.png",
                              fit: BoxFit.cover,
                              color: white,
                              scale: 7,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                    channelId: call.callId,
                                    call: call,
                                    isGroupChat: false,
                                  ),
                                ),
                              );
                            },
                            icon: Image.asset(
                              "assets/icons/call.png",
                              fit: BoxFit.cover,
                              color: white,
                              scale: 7,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
