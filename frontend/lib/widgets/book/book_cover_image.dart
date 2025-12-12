import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/image_utils.dart';

class BookCoverImage extends StatelessWidget {
  final String coverImageUrl;
  final double height;
  final Logger? logger;

  const BookCoverImage({
    super.key,
    required this.coverImageUrl,
    this.height = 300,
    this.logger,
  });

  @override
  Widget build(BuildContext context) {
    if (coverImageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    final absoluteUrl = getAbsoluteImageUrl(coverImageUrl);

    return CachedNetworkImage(
      imageUrl: absoluteUrl,
      height: height,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholderFadeInDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Container(
        height: height,
        width: AppDimensions.imageWidthL,
        color: AppColors.surface,
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        logger?.w('Failed to load cover image: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: AppDimensions.imageWidthL,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.primaryWithOpacity(0.3),
          width: AppDimensions.borderWidthMedium,
        ),
      ),
      child: Icon(
        Icons.terminal,
        size: AppDimensions.iconHuge,
        color: AppColors.primary,
      ),
    );
  }
}
