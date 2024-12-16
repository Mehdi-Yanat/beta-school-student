import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:screen_protector/screen_protector.dart'; // Import screen_protector package

import '../theme/color.dart';

class ViewChapterScreen extends StatefulWidget {
  final String chapterId;

  const ViewChapterScreen({Key? key, required this.chapterId})
      : super(key: key);

  @override
  _ViewChapterScreenState createState() => _ViewChapterScreenState();
}

class _ViewChapterScreenState extends State<ViewChapterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // FlickManager controller for video playback
  late FlickManager flickManager;

  final List<Map<String, String>> _episodes = [
    {
      "title": "Introduction to UI/UX",
      "duration": "10 minutes",
      "url":
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    },
    {
      "title": "UI/UX Research",
      "duration": "12 minutes",
      "url":
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
    },
    {
      "title": "Wireframing",
      "duration": "15 minutes",
      "url":
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize FlickManager with the first episode URL
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(_episodes[0]['url']!),
    );

    // Protect the screen to prevent screen recording or leakage
    ScreenProtector.protectDataLeakageWithBlur();
  }

  void _changeVideo(String url) {
    // Dispose the current flickManager and create a new one
    flickManager.dispose();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(url),
    );
    setState(() {}); // Rebuild the widget to reflect the new video
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text(
          "UI/UX Design",
          style: TextStyle(color: AppColor.textColor),
        ),
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.textColor),
      ),
      body: Column(
        children: [
          // Improved Video Player Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2), // Shadow direction: bottom right
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height *
                    0.25, // Responsive height
                child: VisibilityDetector(
                  key: ObjectKey(flickManager),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction == 0 && this.mounted) {
                      flickManager.flickControlManager?.autoPause();
                    } else if (visibility.visibleFraction == 1) {
                      flickManager.flickControlManager?.autoResume();
                    }
                  },
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      controls: FlickPortraitControls(), // Portrait controls
                    ),
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      controls: FlickLandscapeControls(), // Landscape controls
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Tabs for Lessons and Attachments
          TabBar(
            controller: _tabController,
            labelColor: AppColor.primary,
            unselectedLabelColor: Colors.white,
            indicatorColor: AppColor.primary,
            tabs: [
              Tab(text: "Lessons"),
              Tab(text: "Attachments"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lessons Tab
                ListView.builder(
                  itemCount: _episodes.length,
                  itemBuilder: (context, index) {
                    final episode = _episodes[index];
                    return ListTile(
                      leading: Icon(Icons.play_circle_fill,
                          color: AppColor.primary, size: 40),
                      title: Text(
                        episode["title"]!,
                        style: TextStyle(color: AppColor.textColor),
                      ),
                      subtitle: Text(
                        episode["duration"]!,
                        style: TextStyle(
                            color: AppColor.textColor.withOpacity(0.7)),
                      ),
                      onTap: () {
                        _changeVideo(
                            episode["url"]!); // Change the video when tapped
                      },
                    );
                  },
                ),
                // Attachments Tab
                Center(
                  child: Text(
                    "No attachments available",
                    style: TextStyle(color: AppColor.textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
