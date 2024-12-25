import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class CourseImage extends StatelessWidget {
  const CourseImage({
    required this.thumbnailUrl,
    required this.iconUrl,
    this.width = 280,
    this.height = 190,
  });

  final String? thumbnailUrl;
  final String? iconUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildThumbnail(),
        _buildIconOverlay(),
      ],
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          _buildBlurredImage(),
          _buildGradientOverlay(),
        ],
      ),
    );
  }

  Widget _buildBlurredImage() {
    final imageUrl = thumbnailUrl ?? "assets/images/default_course.png";
    final isNetwork = thumbnailUrl?.startsWith('http') ?? false;

    if (!isNetwork) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
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
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
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
    final imageUrl = iconUrl ?? "assets/images/course_icon.png";
    final isNetwork = iconUrl?.startsWith('http') ?? false;

    if (!isNetwork) {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildPlaceholder() => Center(
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
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.5),
            ],
          ),
        ),
      );
}
