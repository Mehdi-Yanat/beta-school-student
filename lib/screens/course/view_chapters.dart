import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization
import 'package:online_course/services/student_service.dart';
import 'package:online_course/widgets/StarRating.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../providers/course_provider.dart';
import '../../services/course_service.dart';
import '../../theme/color.dart';
import '../../utils/helper.dart';
import '../../widgets/LikeListTile.dart';
import '../../widgets/ToggleIconBtn.dart';
import '../../widgets/appbar.dart';

class ViewChapterScreen extends StatefulWidget {
  final chapterId;
  final courseId;
  final chapter;

  const ViewChapterScreen(
      {Key? key, required this.chapterId, this.courseId, this.chapter})
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

  late CourseProvider _courseProvider;

  Duration _lastPosition = Duration.zero; // Track the last recorded position
  int _watchDuration = 0;

  bool _isChangingVideo = false;
  bool _isDataFetched = false; // Tracks whether data was fetched

  Map<String, dynamic>? _chapterData; // Nullable Map to hold chapter details.

  bool _isScreenActive = true;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    _isScreenActive = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      courseProvider.fetchCourse(widget.courseId, context);
      courseProvider.fetchChaptersForCourse(widget.courseId, context);
      // Or any other provider updates
      _fetchChapterData(widget.chapterId.toString());
      courseProvider.setCurrentChapter(widget.chapter);
    });

    // Initialize TabController for the TabBar
    _tabController = TabController(length: 3, vsync: this);

    // Initialize data protection feature
    ScreenProtector.protectDataLeakageWithBlur();

    // Register lifecycle observer for app state changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _courseProvider = Provider.of<CourseProvider>(context, listen: false);
    if (!_isDataFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final courseProvider =
            Provider.of<CourseProvider>(context, listen: false);
        courseProvider.fetchCourse(widget.courseId, context);
        courseProvider.fetchChaptersForCourse(widget.courseId, context);
        //_fetchChapterData(widget.chapterId.toString());
        courseProvider.setCurrentChapter(widget.chapter);
        courseProvider.checkChapterIsRated(widget.chapterId, context);
      });
      _isDataFetched = true;
    }
  }

  Future<void> _fetchChapterData(String chapterId) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final chapterData = await CourseService.viewChapter(chapterId);
      final provider = Provider.of<CourseProvider>(context, listen: false);

      if (chapterData != null && chapterData['url'] != null) {
        final videoUrl = chapterData['url'];

        if (_isScreenActive == true) {
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
            'title': widget.chapter.title ?? provider.courseData?['title'],
          });
        }

        await _changeVideo(videoUrl);
      } else {
        if (!mounted) return;
        setState(() {
          _isError = true;
        });
        SnackBarHelper.showErrorSnackBar(
            context, AppLocalizations.of(context)!.failed_to_play_video);
      }
    } catch (e) {
      if (!mounted) return;
      print('Error fetching chapter data: $e');
      setState(() {
        _isError = true;
      });
      SnackBarHelper.showErrorSnackBar(
          context, AppLocalizations.of(context)!.failed_to_load_chapter);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeVideo(String url) async {
    _currentUrl = url;

    try {
      // Safely create a new VideoPlayerController instance
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

      // Load the video and wait for initialization
      await _videoController!.initialize();

      if (!mounted || _currentUrl != url)
        return; // Exit early if unmounted or changed

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

        if (!mounted) return; // Check again if widget is still active
        setState(() {}); // Update the UI
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarHelper.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.failed_to_play_video,
      );
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

      if (!mounted) return;

      // Reset the last position and watch duration
      _lastPosition = Duration.zero;
      _watchDuration = 0;

      // Initialize the new video
      await _initializeVideo(url);
    } finally {
      _isChangingVideo = false; // Unblock changes after completion
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause video playback when app moves to background
    if ((state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused) &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      _videoController!.pause();
      _sendWatchDuration();
    }

    // Resume video playback when app comes back to foreground
    if (state == AppLifecycleState.resumed &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      _videoController!.play();
    }
  }

  @override
  void deactivate() {
    super.deactivate();

    // Remove the listener BEFORE pausing the video
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);

      if (_videoController!.value.isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_videoController != null && mounted) {
            _videoController!.pause();
          }
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted || !_isScreenActive || _videoController == null) return;

    final currentPosition = _videoController!.value.position;
    final elapsedTime = currentPosition.inSeconds - _lastPosition.inSeconds;
    print('Current position: ${currentPosition.inSeconds} s');
    print('Last position: ${_lastPosition.inSeconds} s');

    // Accumulate watch duration if the video is playing
    if (_videoController!.value.isPlaying) {
      if (elapsedTime > 0) {
        // Prevent rapid updates
        _watchDuration += elapsedTime;
        _lastPosition = currentPosition;
        print('Watch duration: $_watchDuration seconds');
      }
    } else {
      // Video is paused, send the watch duration
      if (_watchDuration > 0) {
        print(
            'Video is paused. Sending watch duration: $_watchDuration seconds');
        _sendWatchDuration();
        _watchDuration = 0; // Reset after sending
      }
      _lastPosition = currentPosition; // Update last position even if paused
    }

    // Defer state updates until the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isScreenActive) return;
      setState(() {
        // Any necessary state updates
      });
    });
  }

  void _sendWatchDuration() {
    print('Sending watch duration: $_watchDuration');
    StudentService.trackWatchTime(
        _watchDuration, _courseProvider.currentChapter!.id);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization strings
    final courseProvider = Provider.of<CourseProvider>(context);
    final chapters = courseProvider.courseChapters;

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: localizations!.chapter_title, // Screen title localized
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            )
          : _isError
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
                                text: AppLocalizations.of(context)!
                                    .about_chapter_title),
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
                              Container(
                                padding: EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseProvider.currentChapter!.title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.darker,
                                        ),
                                      ),
                                      Text(
                                        courseProvider
                                            .currentChapter!.description,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.mainColor
                                              .withValues(alpha: 0.75),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      if (courseProvider
                                              .currentChapter?.rating !=
                                          null)
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                      .chapter_rating +
                                                  ": ",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            StarRating(
                                              color: AppColor.yellow,
                                              starCount: 5,
                                              rating: courseProvider
                                                      .currentChapter!.rating! *
                                                  5,
                                              size: 22,
                                            ),
                                            Text(
                                              ((courseProvider
                                                  .currentChapter!.rating ?? 0) * 5)
                                                  .toStringAsFixed(1),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        children: [
                                          Text(
                                            " " +
                                                AppLocalizations.of(context)!
                                                    .chapter_views +
                                                ": ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: AppColor.primary,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            courseProvider.currentChapter!.views.toString() +
                                                " " +
                                                AppLocalizations.of(context)!
                                                    .a_view,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            " " +
                                                AppLocalizations.of(context)!
                                                    .watch_time +
                                                ": ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Icon(
                                            Icons.timelapse_rounded,
                                            color: AppColor.primary,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            Helpers.formatHoursAndMinutes(
                                                context,
                                                courseProvider
                                                    .currentChapter!.duration),
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .did_you_like_chapter,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.mainColor,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomCenter,
                                        child: ToggleIconBtnsFb1(
                                            whichSelected: courseProvider
                                                    .currentChapterRating
                                                    .isEmpty
                                                ? []
                                                : courseProvider
                                                            .currentChapterRating[
                                                        'isRated']
                                                    ? courseProvider
                                                                .currentChapterRating[
                                                            'liked']
                                                        ? [true, false]
                                                        : [false, true]
                                                    : [],
                                            selectedColor: AppColor.blue,
                                            icons: List<Icon>.from([
                                              Icon(Icons.thumb_up_rounded),
                                              Icon(Icons.thumb_down)
                                            ]),
                                            selected: (index) async {
                                              if (index == 0) {
                                                await courseProvider
                                                    .rateChapter(
                                                        widget.chapterId,
                                                        true,
                                                        context);
                                              } else {
                                                await courseProvider
                                                    .rateChapter(
                                                        widget.chapterId,
                                                        false,
                                                        context);
                                              }
                                            }),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Lessons Tab
                              ListView.builder(
                                itemCount: chapters.length,
                                itemBuilder: (context, index) {
                                  final chapter = chapters[index];
                                  return chapter != null
                                      ? GestureDetector(
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25),
                                              child: LikeListTile(
                                                imgUrl: chapter.thumbnail.url,
                                                title: '${index + 1}. ' +
                                                    chapter.title,
                                                likes: chapter.views.toString(),
                                                color: AppColor.primary,
                                                subtitle: Helpers
                                                    .formatHoursAndMinutes(
                                                        context,
                                                        chapter.duration),
                                                subtitle2:
                                                    chapter.rating != null
                                                        ? (chapter.rating! * 5)
                                                            .toStringAsFixed(1)
                                                        : null,
                                              )),
                                          onTap: () async {
                                            try {
                                              final chapterData =
                                                  await CourseService
                                                      .viewChapter(chapter.id);
                                              if (chapterData != null &&
                                                  chapterData['url'] != null) {
                                                Future.microtask(() {
                                                  courseProvider
                                                      .setCurrentChapter(
                                                          chapter);
                                                  courseProvider
                                                      .setCurrentVideo({
                                                    'url': chapterData['url'],
                                                    'chapterId': chapter.id,
                                                    'title': chapter.title
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
                                  final chapter = chapters[index];
                                  final attachments = chapter.attachments;
                                  if (attachments.isEmpty) {
                                    return ListTile(
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .no_attachments_chapter(
                                                chapter.title),
                                        style: TextStyle(
                                            color: AppColor.textColor),
                                      ),
                                    );
                                  }

                                  return ExpansionTile(
                                    title: Text(
                                      '${index + 1}. ' + chapter.title,
                                      style:
                                          TextStyle(color: AppColor.mainColor),
                                    ),
                                    children: attachments.map((attachment) {
                                      final file = attachment.file;
                                      return ListTile(
                                        title: Text(file.fileName),
                                        trailing: Icon(Icons.download,
                                            color: AppColor.primary),
                                        onTap: () async {
                                          final url = file.url;
                                          try {
                                            await launchUrl(Uri.parse(url));
                                          } catch (_) {
                                            SnackBarHelper.showErrorSnackBar(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .failed_to_open_attachment);
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

    _sendWatchDuration();
    super.dispose();
  }
}
