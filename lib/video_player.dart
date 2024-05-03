import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      // ignore: deprecated_member_use
      videoPlayerController: VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: const Text("Flutter Video Player"),
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: const FlickVideoWithControls(
              controls: FlickPortraitControls(),
            ),
          ),
        ),
      ),
    );
  }
}
