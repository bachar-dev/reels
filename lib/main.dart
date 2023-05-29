import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


void main(){
  runApp(ReelsPage());
}
class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final List<String> videos = [
  
    'Videos/surah1.mp4',
    'Videos/surah2.mp4',
     
  ];
  int _videoIndex = 0;
  late PageController _pageController;
  late VideoPlayerController _controller;
   Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

     _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset(videos[_videoIndex]);
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();

    setState(() {
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(  
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {},
            ),
          ],
          title: const Text("Quran Reels"),
        ),
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _videoIndex = index;
            });
            _controller.dispose();
            _initializeVideoPlayer();
          },
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: VideoPlayer(_controller ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      strokeWidth: 10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
