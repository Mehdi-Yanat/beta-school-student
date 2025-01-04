import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:online_course/theme/color.dart';

class CourseImage extends StatelessWidget {
  const CourseImage({
    required this.thumbnailUrl,
    required this.iconUrl,
    this.width = 280,
    this.height = 190,
    this.borderRadius = 15,
    Key? key,
  }) : super(key: key);

  final String? thumbnailUrl;
  final String? iconUrl;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<File?>(
          future: _getOrCreateBlurredImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildPlaceholder(); // Loading placeholder
            }
            if (snapshot.hasError || snapshot.data == null) {
              return _buildErrorWidget(); // Error widget if image processing fails
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                children: [
                  Image.file(
                    snapshot.data!,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                  _buildGradientOverlay(),
                ],
              ),
            );
          },
        ),
        _buildIconOverlay(),
      ],
    );
  }

  /// Builds or retrieves the blurred image file.
  Future<File?> _getOrCreateBlurredImage() async {
    try {
      final imageUrl = thumbnailUrl ?? "assets/images/course_icon.png";
      final fileName = Uri.parse(imageUrl).pathSegments.last;
      final blurredFileName = "blurred_$fileName";
      final tempDir = await getTemporaryDirectory();
      final blurredFile = File('${tempDir.path}/$blurredFileName');

      // If the blurred file already exists, return it.
      if (await blurredFile.exists()) {
        return blurredFile;
      }

      // Otherwise, create the blurred image file from the original image.
      final Uint8List? blurredBytes = await _generateBlurredImage(imageUrl);
      if (blurredBytes != null) {
        await blurredFile.writeAsBytes(blurredBytes);
        return blurredFile;
      }
    } catch (e) {
      debugPrint("Error creating blurred image: $e");
    }
    return null; // Return null in case of an error
  }

  /// Generates a blurred image from the given URL.
  Future<Uint8List?> _generateBlurredImage(String imageUrl) async {
    try {
      // Determine if the image is a network or asset image.
      final Uint8List imageBytes = imageUrl.startsWith('http')
          ? await _downloadImageBytes(imageUrl)
          : await _loadAssetImageBytes(imageUrl);

      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      // Apply the blur effect
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10);
      canvas.drawImage(image, Offset.zero, paint);

      // Finalize the blurred image and convert to byte data
      final ui.Image blurredImage = await recorder.endRecording().toImage(image.width, image.height);
      final ByteData? byteData = await blurredImage.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error blurring image: $e");
      return null;
    }
  }

  /// Downloads image bytes from a network URL.
  Future<Uint8List> _downloadImageBytes(String url) async {
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();
    return await consolidateHttpClientResponseBytes(response);
  }

  /// Loads image bytes from an asset.
  Future<Uint8List> _loadAssetImageBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Widget _buildIconOverlay() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: _buildIconImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildIconImage() {
    final imageUrl = iconUrl != null && iconUrl!.isNotEmpty
        ? iconUrl!
        : "assets/images/course_icon.png";

    return imageUrl.startsWith('http')
        ? CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    )
        : Image.asset(imageUrl, fit: BoxFit.cover);
  }

  Widget _buildPlaceholder() => const Center(
    child: CircularProgressIndicator(
      color: AppColor.mainColor,
      strokeWidth: 2,
    ),
  );

  Widget _buildErrorWidget() => Icon(
    Icons.image_not_supported_outlined,
    color: Colors.grey[400],
    size: 24,
  );

  Widget _buildGradientOverlay() => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.1),
          Colors.black.withOpacity(0.5),
        ],
      ),
    ),
  );
}