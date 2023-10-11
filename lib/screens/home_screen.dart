// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:asa_video_and_music/utils/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<File> _files = [];

  Future<void> fetchMediaFiles() async {
    final directories = [
      Directory('/storage/emulated/0/Download'),
      Directory('/storage/emulated/0/DCIM'),
      Directory('/storage/emulated/0/Movies'),
      Directory('/storage/emulated/0/Documents'),
      Directory('/storage/emulated/0/Music'),
      Directory('/storage/emulated/0/Pictures'),
      Directory('/storage/emulated/0/Recordings'),
    ];

    List<File> allFiles = [];

    for (var directory in directories) {
      try {
        if (directory.existsSync()) {
          final files = directory
              .listSync(recursive: true)
              .where((entity) {
                return entity is File &&
                    (entity.path.endsWith('.mp3') ||
                        entity.path.endsWith('.mp4'));
              })
              .cast<File>()
              .toList();

          allFiles.addAll(files);
        } else {
          AlertDialog(
            title: Text('Warning!'),
            content: Text('Directory does not exist: ${directory.path}'),
          );
        }
      } catch (e) {
        AlertDialog(
          title: Text('Warning!'),
          content: Text('Error fetching files in $directory: $e'),
        );
      }
    }

    setState(() {
      _files = allFiles;
    });
  }

  Future<Uint8List?> generateVideoThumbnail(String videoPath) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final thumbnailDirectory = appDocumentsDirectory.path;
    try {
      final uint8List = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG, // Use JPEG for higher quality
        maxWidth: 1080, // Set your preferred width
        quality: 100,
        maxHeight: 720
      );

      if (uint8List != null) {
        final File thumbnailFile = File('$thumbnailDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await thumbnailFile.writeAsBytes(uint8List);
        return uint8List;
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchMediaFiles();
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
                  child: _files.isEmpty
                      ? Center(
                          child: Text('No media files found.'),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 15,crossAxisSpacing: 15,
                                  crossAxisCount: 2,childAspectRatio: 1),
                          itemCount: _files.length,
                          itemBuilder: (context, index) {
                            final file = _files[index];
                            final fileName = path.basenameWithoutExtension(file.path);
                            return FutureBuilder<Uint8List?>(
                              future: generateVideoThumbnail(file.path),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayerPage(videoPath: file.path),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        )
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:BorderRadius.circular(16),
                                            child: Image.memory(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Center(child: Text(fileName,style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),)),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), // You can use a loading indicator here
                                  );
                                }
                              },
                            );
                          })),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          fetchMediaFiles();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
