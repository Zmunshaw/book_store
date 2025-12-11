import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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

    return Image.network(
      absoluteUrl,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        logger?.w('Failed to load cover image: $error');
        return _buildPlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          logger?.d('Cover image loaded successfully');
          return child;
        }
        return Container(
          height: height,
          width: AppDimensions.imageWidthL,
          color: AppColors.surface,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
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
