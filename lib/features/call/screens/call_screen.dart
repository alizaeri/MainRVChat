import 'dart:ui';

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
import 'package:rvchat/common/widgets/loademini.dart';
import 'package:rvchat/common/widgets/loader.dart';
import 'package:rvchat/common/widgets/loaderW.dart';
import 'package:rvchat/config/agora_config.dart';
import 'package:rvchat/features/call/controller/call_controller.dart';
import 'package:rvchat/models/call.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

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
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.network(
              widget.call.callerPic,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                  color: grayL1.withOpacity(0.3), child: _remoteVideo()),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  //=> Background Linear Gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    grayL1,
                    grayL1.withOpacity(0),
                    grayL1.withOpacity(0),
                    grayL1.withOpacity(0),
                    grayL1
                  ]),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(child: Container()),
                    const Text(
                      'Appeks Alphadron',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: GestureDetector(
                            child: PopupMenuButton<int>(
                              elevation: 2,
                              color: grayL1.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: const [
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: pink,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                        "Screen Recorder",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: const [
                                      Image(
                                        width: 25,
                                        image: Svg(
                                            'assets/icons/swich_camera.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Swich Camera",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: const [
                                      Image(
                                        width: 25,
                                        image:
                                            Svg('assets/icons/camera_off.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Turn Off Camera",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: const [
                                      Image(
                                        width: 25,
                                        image: Svg('assets/icons/layout.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Change Layout",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: const [
                                      Image(
                                        width: 25,
                                        image:
                                            Svg('assets/icons/invisible.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Hide Button",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              initialValue: 0,
                              onSelected: (value) async {},
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          color: white,
                        ),
                      ],
                    )),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(child: Container()),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: white,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(77),
                          child: _localPreview(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20)
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Image(
                          width: 300,
                          height: 87,
                          image: Svg('assets/images/bg_nav.svg'),
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
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
                                elevation: 0,
                                fillColor: white.withOpacity(0.2),
                                padding: const EdgeInsets.all(5),
                                //padding: const EdgeInsets.all(0),
                                child: micIcon
                                    ? const Image(
                                        image: Svg('assets/icons/sp_n.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                        width: 35,
                                      )
                                    : Image(
                                        image: const Svg(
                                            'assets/icons/sp_off.svg'),
                                        fit: BoxFit.cover,
                                        color: white.withOpacity(0.5),
                                        width: 35,
                                      ),
                              ),
                              const SizedBox(width: 16),
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
                                elevation: 0,
                                fillColor: white,
                                padding: const EdgeInsets.all(2),
                                child: const Image(
                                  image: Svg('assets/icons/call_end.svg'),
                                  fit: BoxFit.cover,
                                  color: pink,
                                  width: 60,
                                ),
                              ),
                              const SizedBox(width: 16),
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
                                elevation: 0,
                                fillColor: white.withOpacity(0.2),
                                padding: const EdgeInsets.all(5),
                                //padding: const EdgeInsets.all(0),
                                child: micIcon
                                    ? const Image(
                                        image: Svg('assets/icons/mic_n.svg'),
                                        fit: BoxFit.cover,
                                        color: white,
                                        width: 35,
                                      )
                                    : Image(
                                        image: const Svg(
                                            'assets/icons/mic_off.svg'),
                                        fit: BoxFit.cover,
                                        color: white.withOpacity(0.5),
                                        width: 35,
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          const SizedBox(height: 50)
        ],
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
      if (_isJoined) msg = 'Connecting...';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Loadermini(),
            const SizedBox(width: 50),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "yknir",
                  fontWeight: FontWeight.w300,
                  fontSize: 30,
                  color: white),
            ),
          ],
        ),
      );
    }
  }
}
