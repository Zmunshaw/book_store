import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../widgets/book/book_cover_image.dart';
import '../widgets/book/book_info_section.dart';
import '../widgets/add_to_collection_dialog.dart';

class BookDetailView extends StatefulWidget {
  final Book book;

  const BookDetailView({super.key, required this.book});

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _logger.i('BookDetailView opened for: ${widget.book.title}');
    _logger.d('Author: ${widget.book.authorFirst} ${widget.book.authorLast}');
    _logger.d('ID: ${widget.book.id}');
    _logger.d('Cover URL: ${widget.book.coverImageUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title.toUpperCase(),
          style: AppTextStyles.headlineMedium.copyWith(
            letterSpacing: AppDimensions.letterSpacingLoose,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: AppDimensions.paddingL,
                child: BookCoverImage(
                  coverImageUrl: widget.book.coverImageUrl,
                  height: 300,
                  logger: _logger,
                ),
              ),
            ),
            BookInfoSection(book: widget.book),
            if (AuthService.isLoggedIn())
              Padding(
                padding: AppDimensions.paddingL,
                child: FilledButton.icon(
                  onPressed: _showAddToCollectionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add to Collection'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }

  void _showAddToCollectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddToCollectionDialog(book: widget.book),
    );
  }
}
