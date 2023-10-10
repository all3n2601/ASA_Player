// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {

  final String videoPath;
 VideoPlayerScreen({required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: VideoPlayer(VideoPlayerController.file(File(videoPath)))),
    );
  }
}