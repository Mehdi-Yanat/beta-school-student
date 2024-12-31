import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization
import 'package:chewie/chewie.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
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

  Map<String, dynamic>? _chapterData; // Nullable Map to hold chapter details.

  bool _isScreenActive = true;

  @override
  void initState() {
    super.initState();

    _isScreenActive = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      courseProvider
          .fetchCourse(widget.courseId); // Or any other provider updates
      _fetchChapterData(widget.chapterId.toString());
    });

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

    if (!_isDataFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final courseProvider =
            Provider.of<CourseProvider>(context, listen: false);
        courseProvider.fetchCourse(widget.courseId);
        _fetchChapterData(widget.chapterId.toString());
      });
      _isDataFetched = true;
    }
  }

  Future<void> _fetchChapterData(String chapterId) async {
    try {
      final chapterData = await CourseService.viewChapter(chapterId);

      if (chapterData != null && chapterData['url'] != null) {
        final videoUrl = chapterData['url'];
        final provider = Provider.of<CourseProvider>(context, listen: false);

        if (_isScreenActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _chapterData = chapterData;
            });
          });
        }

        if (provider.currentVideo == null ||
            provider.currentVideo?['url'] != videoUrl) {
          provider.setCurrentVideo({
            'url': videoUrl,
            'chapterId': chapterId,
            'title': provider.courseData?['title']
          });
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
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

      // Load the video and wait for initialization
      await _videoController!.initialize();

      _videoController!.addListener(_videoListener);

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
    _isScreenActive = false;

    // Stop listening to VideoPlayerController events
    if (_videoController != null) {
      _videoController!
          .removeListener(_videoListener); // Ensure listeners are removed
      if (_videoController!.value.isInitialized) {
        _videoController!.pause(); // Pause any playback
      }
      _videoController!.dispose(); // Dispose of the controller
      _videoController = null; // Nullify for safety
    }

    // Dispose the ChewieController
    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null; // Nullify for safety
    }

    // Clean up tab controller and lifecycle observers
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

    // Pause the video playback safely without triggering build
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
    }
  }

  void _videoListener() {
    // Ensure this listener fires only when mounted and active
    if (!mounted || !_isScreenActive) return;

    // Defer state updates until the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        // Any necessary state updates
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization strings
    final courseProvider = Provider.of<CourseProvider>(context);
    final chapters = courseProvider.courseChapters;

    print("provider.currentVideo ${courseProvider.currentVideo}");

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
              : _chapterData == null
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
                              if (courseProvider.currentVideo?["title"] != null)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseProvider.currentVideo?['title'] ??
                                            'No Title',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
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
                                itemCount: chapters.length,
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
                                                Future.microtask(() {
                                                  courseProvider
                                                      .setCurrentChapter(
                                                          chapter);
                                                  courseProvider
                                                      .setCurrentVideo({
                                                    'url': chapterData['url'],
                                                    'chapterId': chapter['id'],
                                                    'title': chapter['title']
                                                  });
                                                });
                                                await _changeVideo(
                                                    chapterData['url']);
                                              } else {
                                                SnackBarHelper
                                                    .showErrorSnackBar(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .failed_to_play_video,
                                                );
                                              }
                                            } catch (e) {
                                              SnackBarHelper.showErrorSnackBar(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .failed_to_load_chapter,
                                              );
                                            }
                                          })
                                      : SizedBox.shrink();
                                },
                              ),

                              // Attachments Tab
                              ListView.builder(
                                itemCount: chapters.length,
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
