import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/enums/message_enum.dart';
import 'package:rvchat/features/chat/widget/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final bool isSeen;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.type,
      required this.isSeen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(20),
            ),
          ),
          color: bgmmColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              SizedBox(width: 80),
              Padding(
                padding: type == MessageEnum.text
                    ? EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      )
                    : const EdgeInsets.only(
                        left: 5,
                        top: 5,
                        right: 5,
                        bottom: 25,
                      ),
                child: DisplayTextImageGIF(
                  message: message,
                  type: type,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: isSeen ? Colors.blue : Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
