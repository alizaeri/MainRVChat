import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/enums/message_enum.dart';
import 'package:rvchat/features/chat/widget/video_player_item.dart';
import 'package:rvchat/models/message.dart';

class DisplayTextImageGIFSender extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIFSender(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16, color: grayL1),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: isPlaying
                      ? Icon(Icons.pause_circle)
                      : Icon(Icons.play_circle),
                );
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
