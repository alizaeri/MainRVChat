import 'package:agora_rtc_engine/src/binding_forward_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:agora_uikit/agora_uikit.dart';

// import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
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
  // AgoraClient? client;
  late RtcEngine agoraEngine;
  String baseUrl =
      'https://flutter-twitch-server-production-f453.up.railway.app/';

  bool localUserJoined = false;
  int uid = 0;
  bool _isJoined = false;
  int? _remoteUid;
  late String token;
  bool toggleVideo = false;

  bool micIcon = false;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    // client = AgoraClient(
    //   agoraConnectionData: AgoraConnectionData(
    //       appId: AgoraConfig.appId,
    //       channelName: widget.channelId,
    //       tokenUrl: baseUrl,
    //       uid: uid,
    //       rtmEnabled: false),
    //   enabledPermission: [Permission.camera, Permission.microphone],
    setupVideoSDKEngine();

    // );

    // initAgora();
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(
      appId: AgoraConfig.appId,
    ));

    await agoraEngine.enableVideo();

//************************************************************************************************************************** */
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await getToken();

    await agoraEngine.joinChannel(
      token: token,
      channelId: widget.channelId,
      options: options,
      uid: uid,
    );
    //******************************************************************************** */

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
            localUserJoined = false;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(baseUrl +
              'rtc/' +
              widget.channelId +
              '/publisher/uid/' +
              uid.toString()
          // To add expiry time uncomment the below given line with the time in seconds
          // + '?expiry=45'
          ),
    );

    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
      });
    } else {
      print('Failed to fetch the token');
    }
  }

  // void initAgora() async {
  //   try {
  //     await client!.initialize();
  //     await client!.engine.enableDualStreamMode(enabled: true);

  //     client!.engine.registerEventHandler(
  //       RtcEngineEventHandler(
  //         onJoinChannelSuccess: (connection, elapsed) => setState(() async {
  //           await toggleCamera(
  //             sessionController: client!.sessionController,
  //           );

  //           localUserJoined = true;
  //           await toggleCamera(
  //             sessionController: client!.sessionController,
  //           );
  //         }),
  //       ),
  //     );
  //     VideoEncoderConfiguration videoConfig = const VideoEncoderConfiguration(
  //         mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
  //         frameRate: 5,
  //         bitrate: standardBitrate,
  //         dimensions: VideoDimensions(width: 320, height: 240),
  //         orientationMode: OrientationMode.orientationModeAdaptive,
  //         degradationPreference: DegradationPreference.maintainBalanced);
  //     await client!.engine.setVideoEncoderConfiguration(videoConfig);
  //     await client!.engine.setRemoteVideoStreamType(
  //         uid: 0, streamType: VideoStreamType.videoStreamLow);
  //   } catch (e) {
  //     // this logs that above error.
  //     await client!.initialize();
  //   }
  // }

  @override
  void dispose() async {
    super.dispose();
    // await agoraEngine.leaveChannel();
    await agoraEngine.release();
    await FirebaseFirestore.instance
        .collection('call')
        .doc(
          widget.call.callerId,
        )
        .delete();
    await FirebaseFirestore.instance
        .collection('call')
        .doc(widget.call.receiverId)
        .delete();

    // client!.engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  client == null &&
      body: SafeArea(
        child: ListView(
          children: [
            // AgoraVideoViewer(
            //   client: client!,
            //   layoutType: Layout.floating,
            //   // floatingLayoutContainerHeight: 200,
            //   // floatingLayoutContainerWidth: 200,
            //   // showNumberOfUsers: true,
            //   // showAVState: true,
            // ),

            Container(
              height: 350,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: _localPreview()),
            ),
            Container(
              height: 350,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: _remoteVideo()),
            ),
            Row(
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    if (micIcon) {
                      setState(() {
                        agoraEngine.enableAudio();

                        micIcon = false;
                      });
                    } else {
                      setState(() {
                        micIcon = true;
                        agoraEngine.disableAudio();
                      });
                    }
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
                const SizedBox(width: 10),
                RawMaterialButton(
                  onPressed: () {
                    leave();
                    ref.read(callControllerProvider).endCall(
                          widget.call.callerId,
                          widget.call.receiverId,
                          context,
                        );
                    Navigator.pop(context);
                    agoraEngine.leaveChannel();
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
                RawMaterialButton(
                  onPressed: () {
                    agoraEngine.switchCamera();
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
                RawMaterialButton(
                  onPressed: () async {
                    if (toggleVideo) {
                      setState(() {
                        agoraEngine.muteLocalVideoStream(false);

                        toggleVideo = false;
                      });
                    } else {
                      setState(() {
                        toggleVideo = true;

                        agoraEngine.muteLocalVideoStream(true);
                      });
                    }
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
              ],
            ),
            // AgoraVideoButtons(
            //   client: client!,
            //   muteButtonChild: RawMaterialButton(
            //     onPressed: () {
            //       if (micIcon) {
            //         setState(() {
            //           micIcon = false;
            //         });
            //       } else {
            //         setState(() {
            //           micIcon = true;
            //         });
            //       }

            //       // toggleMute(
            //       //   sessionController: client!.sessionController,
            //       // );
            //     },
            //     shape: const CircleBorder(),
            //     elevation: 2.0,
            //     fillColor: grayL1,
            //     padding: const EdgeInsets.all(14),
            //     //padding: const EdgeInsets.all(0),
            //     child: micIcon
            //         ? Image.asset(
            //             "assets/icons/mic_i.png",
            //             fit: BoxFit.cover,
            //             color: white,
            //             scale: 7,
            //           )
            //         : Image.asset(
            //             "assets/icons/mic_a.png",
            //             fit: BoxFit.cover,
            //             color: white,
            //             scale: 7,
            //           ),
            //   ),
            //   switchCameraButtonChild: RawMaterialButton(
            //     onPressed: () {
            //       // switchCamera(
            //       //   sessionController: client!.sessionController,
            //       // );
            //     },
            //     shape: const CircleBorder(),
            //     elevation: 2.0,
            //     fillColor: grayL1,
            //     padding: const EdgeInsets.all(14),
            //     //padding: const EdgeInsets.all(0),
            //     child: Image.asset(
            //       "assets/icons/camera-sw.png",
            //       fit: BoxFit.cover,
            //       color: white,
            //       scale: 7,
            //     ),
            //   ),
            //   disconnectButtonChild: RawMaterialButton(
            //     onPressed: () async {
            //       // await client!.engine.leaveChannel();
            //       ref.read(callControllerProvider).endCall(
            //             widget.call.callerId,
            //             widget.call.receiverId,
            //             context,
            //           );
            //       Navigator.pop(context);
            //     },
            //     shape: const CircleBorder(),
            //     elevation: 2.0,
            //     fillColor: pink,
            //     padding: const EdgeInsets.all(14),
            //     child: Image.asset(
            //       "assets/icons/call_end.png",
            //       fit: BoxFit.cover,
            //       color: white,
            //       scale: 5,
            //     ),
            //   ),
            //   disableVideoButtonChild: RawMaterialButton(
            //     onPressed: () async {
            //       // await toggleCamera(
            //       //   sessionController: client!.sessionController,
            //       // );
            //     },
            //     shape: const CircleBorder(),
            //     elevation: 2.0,
            //     fillColor: grayL1,
            //     padding: const EdgeInsets.all(14),
            //     //padding: const EdgeInsets.all(0),
            //     child: Image.asset(
            //       "assets/icons/camera_off.png",
            //       fit: BoxFit.cover,
            //       color: white,
            //       scale: 7,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
