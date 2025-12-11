import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class BookInfoSection extends StatelessWidget {
  final Book book;

  const BookInfoSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.paddingL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title.toUpperCase(),
            style: AppTextStyles.displayMedium.copyWith(
              letterSpacing: AppDimensions.letterSpacingRelaxed,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            '> by ${book.authorFirst} ${book.authorLast}'.toUpperCase(),
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.secondary,
              letterSpacing: AppDimensions.letterSpacingNormal,
            ),
          ),
          SizedBox(height: AppDimensions.spacingL),
          if (book.publishedDate.year > 1)
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: AppDimensions.iconS,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimensions.spacingS),
                Text(
                  '> PUBLISHED: ${book.publishedDate.year}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    letterSpacing: AppDimensions.letterSpacingNormal,
                  ),
                ),
              ],
            ),
          SizedBox(height: AppDimensions.spacingL),
          if (book.genres.isNotEmpty) ...[
            Text(
              '> GENRES',
              style: AppTextStyles.headlineMedium.copyWith(
                letterSpacing: AppDimensions.letterSpacingLoose,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            Wrap(
              spacing: AppDimensions.spacingS,
              runSpacing: AppDimensions.spacingS,
              children: book.genres.map((genre) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingXs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(
                      color: AppColors.secondaryWithOpacity(0.5),
                      width: AppDimensions.borderWidthThin,
                    ),
                    borderRadius: AppDimensions.borderRadiusXs,
                  ),
                  child: Text(
                    genre.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: AppDimensions.letterSpacingNormal,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.spacingL),
          ],
          if (book.synopsis.isNotEmpty) ...[
            Text(
              '> SYNOPSIS',
              style: AppTextStyles.headlineMedium.copyWith(
                letterSpacing: AppDimensions.letterSpacingLoose,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              book.synopsis,
              style: AppTextStyles.bodyLarge.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
