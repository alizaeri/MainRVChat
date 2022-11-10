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
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xff128c7e),
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMesseage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
//3:45 daghighe
