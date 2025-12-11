import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';

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
            if (widget.book.coverImageUrl.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    widget.book.coverImageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      _logger.w('Failed to load cover image: $error');
                      return Container(
                        height: 300,
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
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        _logger.d('Cover image loaded successfully');
                        return child;
                      }
                      return Container(
                        height: 300,
                        width: 200,
                        color: const Color(0xFF0D1117),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00FF41),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 300,
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
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00FF41),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '> by ${widget.book.authorFirst} ${widget.book.authorLast}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF00D9FF),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.book.publishedDate.year > 1)
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(0xFF00FF41),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '> PUBLISHED: ${widget.book.publishedDate.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF00FF41),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (widget.book.genres.isNotEmpty) ...[
                    const Text(
                      '> GENRES',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FF41),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.book.genres.map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1117),
                            border: Border.all(
                              color: const Color(0xFF00D9FF).withValues(alpha: 0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF00D9FF),
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.book.synopsis.isNotEmpty) ...[
                    const Text(
                      '> SYNOPSIS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FF41),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.book.synopsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF00FF41),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
