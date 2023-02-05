import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/features/auth/controller/auth_controller.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/features/call/screens/call_screen.dart';
import 'package:rvchat/features/landing/screens/landing_screen.dart';
import 'package:rvchat/models/call.dart';
import 'package:rvchat/widgets/error.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LocalWidget(scaffold: scaffold);
  }
}

class LocalWidget extends ConsumerStatefulWidget {
  const LocalWidget({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  final Widget scaffold;
  @override
  ConsumerState<LocalWidget> createState() => _LocalWidgetState();
}

class _LocalWidgetState extends ConsumerState<LocalWidget> {
  @override
  void initState() {
    // FlutterRingtonePlayer.playNotification();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterRingtonePlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialled) {
            FlutterRingtonePlayer.play(
              android: AndroidSounds.ringtone,
              ios: const IosSound(1023),
              looping: true,
              volume: 0.1,
            );
            return Scaffold(
              body: Stack(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: Image.network(
                      call.callerPic,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.6,
                        decoration: BoxDecoration(
                          color: grayL1.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 94,
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
                                      FlutterRingtonePlayer.stop();
                                      ref.read(callControllerProvider).endCall(
                                            call.callerId,
                                            call.receiverId,
                                            context,
                                          );
                                    },
                                    icon: const Image(
                                      image: Svg('assets/svg/end_call.svg'),
                                      fit: BoxFit.cover,
                                      color: white,
                                      width: 18,
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
                                      FlutterRingtonePlayer.stop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CallScreen(
                                            channelId: call.callId,
                                            call: call,
                                            receiverIsFake: false,
                                            receiverVideoLink: '',
                                            isGroupChat: false,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Image(
                                      image: Svg('assets/svg/call_in.svg'),
                                      fit: BoxFit.cover,
                                      color: white,
                                      width: 18,
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
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return widget.scaffold;
      },
    );
  }
}
