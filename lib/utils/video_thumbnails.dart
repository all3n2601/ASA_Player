
// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatelessWidget {

  final String videoPath;
  VideoThumbnail({super.key, required this.videoPath});

  late VideoPlayerController _controller;

  Future<void> _initializeVideoPlayer() async{
    _controller = VideoPlayerController.file(File(videoPath));
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<void>(future: _initializeVideoPlayer(), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return VideoPlayer(_controller);
        }else{
          return CircularProgressIndicator();
        }
      },),
    );
  }
}