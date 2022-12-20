import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/src/binding_forward_export.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';

import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:agora_uikit/models/agora_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/config/agora_config.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  // AgoraSettings settings = ;
  AgoraClient? client;
  String baseUrl = 'https://agora-token-service-production-fc02.up.railway.app';
  bool localUserJoined = false;
  int uid = 0;

  @override
  void initState() {
    super.initState();

    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: AgoraConfig.appId,
          channelName: widget.channelId,
          tokenUrl: baseUrl,
          uid: uid,
          rtmEnabled: false),
      enabledPermission: [Permission.camera, Permission.microphone],
    );

    initAgora();
  }

  void initAgora() async {
    try {
      await client!.initialize();

      client!.engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) => setState(() async {
            await toggleCamera(
              sessionController: client!.sessionController,
            );
            print("?????joined");
            localUserJoined = true;
            await toggleCamera(
              sessionController: client!.sessionController,
            );
          }),
        ),
      );
    } catch (e) {
      print(
          "exceotion is**************************************************************************************************************: $e"); // this logs that above error.
      await client!.initialize();
    }
  }

  @override
  void dispose() {
    super.dispose();

    client!.engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null && localUserJoined
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(
                    client: client!,
                    // layoutType: Layout.floating,
                    // floatingLayoutContainerHeight: 200,
                    // floatingLayoutContainerWidth: 200,
                    // showNumberOfUsers: true,
                    // showAVState: true,
                  ),
                  AgoraVideoButtons(
                    client: client!,
                    enabledButtons: const [
                      BuiltInButtons.toggleMic,
                      BuiltInButtons.callEnd,
                      BuiltInButtons.switchCamera,
                    ],
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();

                        ref.read(callControllerProvider).endCall(
                              widget.call.callerId,
                              widget.call.receiverId,
                              context,
                            );

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
