// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CustomVideoPlayerController _customVideoPlayerController;

  String assetVideoPath = "assets/videos/sample.mp4";

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  void initializeVideoPlayer() {
    VideoPlayerController videoPlayerController;
    videoPlayerController = VideoPlayerController.asset(assetVideoPath)
      ..initialize().then((value) {
        setState(() {});
      });
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: videoPlayerController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ASA Player',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list),
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF564592)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF564592)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.2, -2),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF564592)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.2, 1),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 236, 126, 76)),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-0.2, -1),
                child: Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle, color: Color(0xFF564592)),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                    children: [
                    CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController),
                ]
              )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: (){},
        child: Icon(Icons.refresh),
      ),
    );
  }
}
