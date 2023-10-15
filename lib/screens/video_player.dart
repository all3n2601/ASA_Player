import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoPath;
  const VideoPlayerScreen({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Center(child: VideoPlayer(VideoPlayerController.file(File(videoPath))))
    ]));
  }



}
