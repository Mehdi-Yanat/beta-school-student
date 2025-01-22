import 'package:flutter/material.dart';
import 'package:online_course/widgets/FullScreenPlayer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url; // Add a parameter to accept the video URL

  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url,
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the video is initialized, display the video with a play button overlay.
          return Center(
            child: Stack(
              alignment: Alignment.center, // Center the button over the video
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller), // Display the video
                ),
                if (!_controller.value.isPlaying) // If the video isn't playing
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      size: 64, // Size of the play button
                      color: Colors.white.withOpacity(0.8),
                    ),
                    onPressed: () {
                      setState(() {
                        _controller
                            .play(); // Start the video when button is pressed
                      });
                    },
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      // Navigate to FullScreenPlayer
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenPlayer(
                            controller: _controller,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          // Show a loading spinner while initializing the video
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
