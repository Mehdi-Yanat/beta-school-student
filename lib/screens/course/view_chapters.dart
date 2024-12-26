import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../theme/color.dart';
import '../../widgets/appbar.dart';

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
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

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
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _initializeVideo(_episodes[0]['url']!);
    ScreenProtector.protectDataLeakageWithBlur();
  }

  Future<void> _initializeVideo(String url) async {
    _videoController = VideoPlayerController.network(url);
    await _videoController.initialize();
    _chewieController?.dispose(); // Dispose of any previous Chewie controller
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColor.primary,
        handleColor: AppColor.primary,
        backgroundColor: Colors.white10,
        bufferedColor: Colors.white38,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _changeVideo(String url) {
    _initializeVideo(url);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localized strings

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: localizations!.chapter_title, // Localized screen title
      ),
      body: Column(
        children: [
          // Video Player Section
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.black,
            child: VisibilityDetector(
              key: ObjectKey(_videoController),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0) {
                  _videoController.pause();
                }
              },
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primary,
                      ),
                    ),
            ),
          ),
          // Tabs Section
          TabBar(
            controller: _tabController,
            labelColor: AppColor.primary,
            unselectedLabelColor: AppColor.mainColor,
            indicatorColor: AppColor.primary,
            tabs: [
              Tab(text: localizations.lessons_tab), // Localized "Lessons"
              Tab(
                  text:
                      localizations.attachments_tab), // Localized "Attachments"
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
                            color: AppColor.textColor.withValues(alpha:0.7)),
                      ),
                      onTap: () {
                        _changeVideo(episode["url"]!);
                      },
                    );
                  },
                ),
                // Attachments Tab
                Center(
                  child: Text(
                    localizations
                        .no_attachments, // Localized "No attachments available"
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
