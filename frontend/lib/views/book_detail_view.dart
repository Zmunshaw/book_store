import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../widgets/book/book_cover_image.dart';
import '../widgets/book/book_info_section.dart';

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
          style: const TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF010409),
        foregroundColor: const Color(0xFF00FF41),
      ),
      backgroundColor: const Color(0xFF010409),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BookCoverImage(
                  coverImageUrl: widget.book.coverImageUrl,
                  height: 300,
                  logger: _logger,
                ),
              ),
            ),
            BookInfoSection(book: widget.book),
          ],
        ),
      ),
    );
  }
}
