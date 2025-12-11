import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onAddPressed;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationS,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.radiusXs),
                      ),
                    ),
                    child: book.coverImageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppDimensions.radiusXs),
                            ),
                            child: Image.network(
                              book.coverImageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.menu_book,
                                    size: AppDimensions.iconXxxl,
                                    color: AppColors.primaryWithOpacity(0.4),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.menu_book,
                              size: AppDimensions.iconXxxl,
                              color: AppColors.primaryWithOpacity(0.4),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingXs + 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimensions.spacingXs - 2),
                      Text(
                        '${book.authorFirst} ${book.authorLast}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onAddPressed != null)
              Positioned(
                top: AppDimensions.spacingXs,
                right: AppDimensions.spacingXs,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAddPressed,
                    borderRadius: BorderRadius.circular(AppDimensions.iconS),
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.spacingXs + 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWithOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.overlayLight,
                            blurRadius: AppDimensions.elevationS,
                            offset: Offset(0, AppDimensions.spacingXs - 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        size: AppDimensions.iconS,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
