import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

    return Image.network(
      coverImageUrl,
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
          width: 200,
          color: const Color(0xFF0D1117),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00FF41),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border.all(
          color: const Color(0xFF00FF41).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.terminal,
        size: 100,
        color: Color(0xFF00FF41),
      ),
    );
  }
}
