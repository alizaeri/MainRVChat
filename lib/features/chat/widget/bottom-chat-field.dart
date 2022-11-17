import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/colors.dart';
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
  @override
  void dispose() {
    super.dispose();
    _messageContoller.dispose();
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
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
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
                          IconButton(
                            onPressed: () {},
                            icon: const ImageIcon(
                                AssetImage("assets/icons/att_iconng.png"),
                                color: Color.fromARGB(255, 159, 146, 225)),
                          ),
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
                        : const AssetImage("assets/icons/mic_icon.png"),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//3:45 daghighe
