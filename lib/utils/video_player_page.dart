// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  VideoPlayerPage({super.key, required this.videoPath});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  double _volumeValue = 1.0; // Initial volume
  double _seekValue = 0.0; //
  bool _isFullScreen = false;

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

  void _toggleFullScreen() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  icon: Icon(Icons.fast_rewind),
                  onPressed: () {
                    setState(() {
                      final newPosition =
                          _controller.value.position - Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
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

                IconButton(
                  icon: Icon(Icons.fast_forward),
                  onPressed: () {
                    setState(() {
                      final newPosition =
                          _controller.value.position + Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.rotate_left),
                  onPressed: () {
                    setState(() {
                      _isFullScreen = !_isFullScreen;
                      _toggleFullScreen();
                    });
                  },
                ),

                // Volume Slider
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),

            Slider(
              value: _volumeValue,
              onChanged: (value) {
                setState(() {
                  _volumeValue = value;
                  _controller.setVolume(value);
                });
              },
            ),
            // Seek Slider
            Slider(
              value: _seekValue,
              onChanged: (value) {
                setState(() {
                  _seekValue = value;
                });
              },
              onChangeEnd: (value) {
                // Seek to the selected position when slider is released
                final newPosition =
                    value * _controller.value.duration.inSeconds;
                _controller.seekTo(Duration(seconds: newPosition.toInt()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
