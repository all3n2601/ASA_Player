// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  VideoPlayerPage({super.key, required this.videoPath});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            CircularProgressIndicator(), // You can use a loading indicator here
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.rotate_left),
                onPressed: () {
                  setState(() {
                    // Rotate the video player by 90 degrees
                    _controller.setVolume(0); // Mute the audio temporarily
                    _controller.pause();

                    _controller = VideoPlayerController.file(
                      File(widget.videoPath),
                      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                    )..initialize().then((_) {
                      // Reapply the previous volume
                      _controller.setVolume(1);

                      // Ensure the new state reflects the change
                      setState(() {});
                    });
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () {
                  setState(() {
                    _controller.setVolume(10);
                  });
                },
              ),
              // Add more buttons for additional functions
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
