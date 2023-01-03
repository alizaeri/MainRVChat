import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/src/binding_forward_export.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/config/agora_config.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/models/call.dart';
import 'package:wakelock/wakelock.dart';

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
  String baseUrl =
      'https://flutter-twitch-server-production-f453.up.railway.app/';

  bool localUserJoined = false;
  int uid = 0;

  bool micIcon = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
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
      client!.engine.setRemoteVideoStreamType(
          uid: 0, streamType: VideoStreamType.videoStreamLow);
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
                alignment: Alignment.bottomCenter,
                children: [
                  AgoraVideoViewer(
                    client: client!,
                    layoutType: Layout.floating,
                    // floatingLayoutContainerHeight: 200,
                    // floatingLayoutContainerWidth: 200,
                    // showNumberOfUsers: true,
                    // showAVState: true,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          //=> Background Linear Gradient
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            grayL1.withOpacity(0),
                            grayL1.withOpacity(0.8)
                          ]),
                    ),
                    height: 250,
                    child: Stack(alignment: Alignment.center, children: [
                      AgoraVideoButtons(
                        client: client!,
                        muteButtonChild: RawMaterialButton(
                          onPressed: () {
                            if (micIcon) {
                              setState(() {
                                micIcon = false;
                              });
                            } else {
                              setState(() {
                                micIcon = true;
                              });
                            }

                            toggleMute(
                              sessionController: client!.sessionController,
                            );
                          },
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          fillColor: grayL1,
                          padding: const EdgeInsets.all(14),
                          //padding: const EdgeInsets.all(0),
                          child: micIcon
                              ? Image.asset(
                                  "assets/icons/mic_i.png",
                                  fit: BoxFit.cover,
                                  color: white,
                                  scale: 7,
                                )
                              : Image.asset(
                                  "assets/icons/mic_a.png",
                                  fit: BoxFit.cover,
                                  color: white,
                                  scale: 7,
                                ),
                        ),
                        switchCameraButtonChild: RawMaterialButton(
                          onPressed: () {
                            switchCamera(
                              sessionController: client!.sessionController,
                            );
                          },
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          fillColor: grayL1,
                          padding: const EdgeInsets.all(14),
                          //padding: const EdgeInsets.all(0),
                          child: Image.asset(
                            "assets/icons/camera-sw.png",
                            fit: BoxFit.cover,
                            color: white,
                            scale: 7,
                          ),
                        ),
                        disconnectButtonChild: RawMaterialButton(
                          onPressed: () async {
                            await client!.engine.leaveChannel();
                            ref.read(callControllerProvider).endCall(
                                  widget.call.callerId,
                                  widget.call.receiverId,
                                  context,
                                );
                            Navigator.pop(context);
                          },
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          fillColor: pink,
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            "assets/icons/call_end.png",
                            fit: BoxFit.cover,
                            color: white,
                            scale: 5,
                          ),
                        ),
                        disableVideoButtonChild: RawMaterialButton(
                          onPressed: () async {
                            await toggleCamera(
                              sessionController: client!.sessionController,
                            );
                          },
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          fillColor: grayL1,
                          padding: const EdgeInsets.all(14),
                          //padding: const EdgeInsets.all(0),
                          child: Image.asset(
                            "assets/icons/camera_off.png",
                            fit: BoxFit.cover,
                            color: white,
                            scale: 7,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }
}
