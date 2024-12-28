import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization
import 'package:chewie/chewie.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../providers/course_provider.dart';
import '../../services/course_service.dart';
import '../../theme/color.dart';
import '../../widgets/appbar.dart';
import '../../widgets/chapter_card.dart';

class ViewChapterScreen extends StatefulWidget {
  final chapterId;
  final courseId;

  const ViewChapterScreen({Key? key, required this.chapterId, this.courseId})
      : super(key: key);

  @override
  _ViewChapterScreenState createState() => _ViewChapterScreenState();
}

class _ViewChapterScreenState extends State<ViewChapterScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  VideoPlayerController?
      _videoController; // Made nullable to prevent initialization issues
  ChewieController? _chewieController;
  String? _currentUrl; // To track which video is currently loaded

  bool _isChangingVideo = false;
  bool _isDataFetched = false; // Tracks whether data was fetched

  @override
  void initState() {
    super.initState();

    // Print chapter ID for debugging purposes
    print("chapterId: ${widget.chapterId.toString()}");

    // Initialize TabController for the TabBar
    _tabController = TabController(length: 2, vsync: this);

    // Initialize data protection feature
    ScreenProtector.protectDataLeakageWithBlur();

    // Register lifecycle observer for app state changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // If data hasn't been fetched yet
    if (!_isDataFetched) {
      // Fetch the list of chapters for the course
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      if (widget.courseId != null) {
        courseProvider
            .fetchCourse(widget.courseId); // Fetch course and its chapters
      }

      // Fetch data for the current chapter
      _fetchChapterData(widget.chapterId.toString());
      _isDataFetched = true;
    }
  }

  Future<void> _fetchChapterData(String chapterId) async {
    try {
      final chapterData = await CourseService.viewChapter(chapterId);

      if (chapterData != null && chapterData['url'] != null) {
        final videoUrl = chapterData['url'];
        final provider = Provider.of<CourseProvider>(context, listen: false);

        if (provider.currentVideo == null ||
            provider.currentVideo?['url'] != videoUrl) {
          provider.setCurrentVideo({'url': videoUrl, 'chapterId': chapterId});
        }

        await _changeVideo(
            videoUrl); // Use await to always wait for it to complete
      } else {
        SnackBarHelper.showErrorSnackBar(
            context, AppLocalizations.of(context)!.failed_to_play_video);
      }
    } catch (e) {
      print('Error fetching chapter data: $e');
      SnackBarHelper.showErrorSnackBar(
          context, AppLocalizations.of(context)!.failed_to_load_chapter);
    }
  }

  Future<void> _initializeVideo(String url) async {
    _currentUrl = url;

    try {
      // Safely create a new VideoPlayerController instance
      _videoController = VideoPlayerController.network(url);

      // Load the video and wait for initialization
      await _videoController!.initialize();

      // Dispose of the ChewieController if it already exists
      if (_chewieController != null) {
        _chewieController!.dispose();
      }

      // Create a new ChewieController
      if (_currentUrl == url) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
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
        setState(() {}); // Update the UI
      }
    } catch (e) {
      if (_currentUrl == url) {
        print('Error initializing video: $e');
        SnackBarHelper.showErrorSnackBar(
            context, AppLocalizations.of(context)!.failed_to_play_video);
      }
    }
  }

  Future<void> _changeVideo(String url) async {
    if (_isChangingVideo) return;
    _isChangingVideo = true; // Block subsequent calls

    try {
      // Dispose the old controller safely
      if (_videoController != null) {
        if (_videoController!.value.isInitialized) {
          await _videoController!.pause();
        }
        await _videoController!.dispose();
        _videoController = null;
      }

      if (_chewieController != null) {
        _chewieController!.dispose();
        _chewieController = null;
      }

      // Initialize the new video
      await _initializeVideo(url);
    } finally {
      _isChangingVideo = false; // Unblock changes after completion
    }
  }

  @override
  void dispose() {
    // Safely dispose of the video controllers
    if (_videoController != null) {
      if (_videoController!.value.isInitialized) {
        _videoController!.pause();
      }
      _videoController!.dispose();
      _videoController = null; // Reset to null
    }

    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null; // Reset to null
    }

    // Other disposals
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause video playback when app moves to background
    if ((state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused) &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      _videoController!.pause();
    }
  }

  @override
  void deactivate() {
    super.deactivate();

    // Safely pause the video if it is initialized
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization strings
    final courseProvider = Provider.of<CourseProvider>(context);
    final chapters = courseProvider.courseChapters;
    final currentVideo = courseProvider.currentVideo;

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: localizations!.chapter_title, // Screen title localized
      ),
      body: courseProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            )
          : courseProvider.error != null
              ? Center(
                  child: Text(
                    courseProvider.error!,
                    style: TextStyle(color: AppColor.textColor),
                  ),
                )
              : currentVideo == null
                  ? Center(
                      child: Text(
                        localizations.no_video_available,
                        style: TextStyle(color: AppColor.textColor),
                      ),
                    )
                  : Column(
                      children: [
                        // Video Player Section
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.black,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Chapter Title
                              if (courseProvider.currentChapter != null)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    courseProvider.currentChapter!['title'] ??
                                        'Untitled Chapter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              // Video Player
                              Expanded(
                                child: _chewieController != null &&
                                        _chewieController!.videoPlayerController
                                            .value.isInitialized
                                    ? Chewie(controller: _chewieController!)
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primary,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        // TabBar Section
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColor.primary,
                          unselectedLabelColor: AppColor.mainColor,
                          indicatorColor: AppColor.primary,
                          tabs: [
                            Tab(
                                text:
                                    AppLocalizations.of(context)!.lessons_tab),
                            Tab(
                                text: AppLocalizations.of(context)!
                                    .attachments_tab),
                          ],
                        ),

                        // TabBarView Section
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Lessons Tab
                              ListView.builder(
                                itemCount: chapters.length ?? 0,
                                itemBuilder: (context, index) {
                                  final chapter =
                                      chapters[index] as Map<String, dynamic>?;
                                  return chapter != null
                                      ? ChapterCard(
                                          chapter: {
                                              ...chapter,
                                              'duration':
                                                  chapter['duration'] ?? 0,
                                              'thumbnail': chapter['thumbnail']
                                                  ?['url'],
                                            },
                                          onTap: () async {
                                            try {
                                              final chapterData =
                                                  await CourseService
                                                      .viewChapter(
                                                          chapter['id']);
                                              if (chapterData != null &&
                                                  chapterData['url'] != null) {
                                                final videoUrl =
                                                    chapterData['url'];
                                                courseProvider
                                                    .setCurrentChapter(chapter);
                                                courseProvider.setCurrentVideo({
                                                  'url': videoUrl,
                                                  'chapterId': chapter['id']
                                                });
                                                await _changeVideo(videoUrl);
                                              } else {
                                                SnackBarHelper.showErrorSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .failed_to_play_video);
                                              }
                                            } catch (e) {
                                              SnackBarHelper.showErrorSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .failed_to_load_chapter);
                                            }
                                          })
                                      : SizedBox.shrink();
                                },
                              ),

                              // Attachments Tab
                              ListView.builder(
                                itemCount: chapters.length ?? 0,
                                itemBuilder: (context, index) {
                                  final chapter =
                                      chapters[index] as Map<String, dynamic>?;
                                  final attachments =
                                      chapter?['attachments'] as List<dynamic>?;
                                  if (attachments == null ||
                                      attachments.isEmpty) {
                                    return ListTile(
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .no_attachments_chapter(
                                                chapter?['title'] ?? ''),
                                        style: TextStyle(
                                            color: AppColor.textColor),
                                      ),
                                    );
                                  }

                                  return ExpansionTile(
                                    title: Text(
                                      chapter?['title'] ?? 'Chapter',
                                      style:
                                          TextStyle(color: AppColor.mainColor),
                                    ),
                                    children: attachments.map((attachment) {
                                      final file = attachment['file'] ?? {};
                                      return ListTile(
                                        title: Text(
                                            file['fileName'] ?? 'Unknown File'),
                                        trailing: Icon(Icons.download,
                                            color: AppColor.primary),
                                        onTap: () async {
                                          final url = file['url'];
                                          if (url != null) {
                                            try {
                                              await launchUrl(Uri.parse(url));
                                            } catch (_) {
                                              SnackBarHelper.showErrorSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .failed_to_open_attachment);
                                            }
                                          }
                                        },
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
