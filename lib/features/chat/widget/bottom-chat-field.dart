import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/enums/message_enum.dart';
import 'package:rvchat/common/utils/utils.dart';
import 'package:rvchat/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({Key? key, required this.recieverUserId})
      : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _bottomChatFieldState();
}

class _bottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageContoller = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _messageContoller.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void openAudio() async {
    final status = await Permission.microphone
        .request(); //Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permmission not Allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMesseage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageContoller.text.trim(),
            widget.recieverUserId,
          );
      setState(() {
        _messageContoller.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: bgmmColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 6, 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      style: TextStyle(color: textMyMessage),
                      controller: _messageContoller,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isShowSendButton = true;
                          });
                        } else {
                          setState(() {
                            isShowSendButton = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,

                        //fillColor: mobileChatBoxColor,
                        prefixIcon: SizedBox(
                          width: 50,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: PopupMenuButton<int>(
                                  elevation: 2,
                                  color: Color.fromARGB(255, 52, 102, 220),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Center(
                                        child: Text(
                                          "Image",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuDivider(),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Center(
                                        child: Text(
                                          "Video",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const PopupMenuDivider(),
                                    const PopupMenuItem(
                                      value: 3,
                                      child: Center(
                                        child: Text(
                                          "Emoji",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  initialValue: 0,
                                  onSelected: (value) {
                                    switch (value) {
                                      case 1:
                                        {
                                          selectImage();
                                          // pickImage(ImageSource.gallery);
                                          break;
                                        }
                                      case 2:
                                        {
                                          selectVideo();
                                          // pickImage(ImageSource.camera);
                                          break;
                                        }
                                      case 3:
                                        {
                                          toggleEmojiKeyboardContainer();
                                          // pickImage(ImageSource.camera);
                                          break;
                                        }
                                    }
                                  },
                                  offset: const Offset(0, -90),
                                  child: const ImageIcon(
                                      AssetImage("assets/icons/att_iconng.png"),
                                      color:
                                          Color.fromARGB(255, 159, 146, 225)),
                                ),
                              )
                              /*
                              IconButton(
                                onPressed: selectImage,
                                icon: GestureDetector(
                                  child: const ImageIcon(
                                      AssetImage("assets/icons/att_iconng.png"),
                                      color: Color.fromARGB(255, 159, 146, 225)),
                                ),
                              ),
                              */
                            ],
                          ),
                        ),
                        hintText: 'Type a message!',
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xff6c5dd2),
                    radius: 25,
                    child: GestureDetector(
                      onTap: sendTextMesseage,
                      child: ImageIcon(
                        isShowSendButton
                            ? const AssetImage("assets/icons/sent_icon.png")
                            : isRecording
                                ? const AssetImage(
                                    "assets/icons/att_iconng.png")
                                : const AssetImage("assets/icons/mic_icon.png"),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              isShowEmojiContainer
                  ? SizedBox(
                      height: 310,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          setState(() {
                            _messageContoller.text =
                                _messageContoller.text + emoji.emoji;
                          });
                          if (!isShowSendButton) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
//3:45 daghighe
