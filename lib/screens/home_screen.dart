// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<File> _files = [];

  Future<void> fetchMediaFiles() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      return;
    }

    try {
      final files = directory!.listSync(recursive: true).where((entity) {
        return entity is File &&
            (entity.path.endsWith('.mp3') || entity.path.endsWith('.mp4'));
      }).cast<File>().toList();



      setState(() {
        _files = files;

      });
    } catch (e) {
      print('Error fetching files: $e');
    }
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
                    : ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          final file = _files[index];
                          return ListTile(

                            title: Text(file.path),
                          );
                        },
                      ),
              ),
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
