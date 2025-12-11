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
        title: Text(widget.book.title),
      ),
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
                        color: Colors.grey[200],
                        child: Icon(Icons.menu_book,
                            size: 100, color: Colors.grey[400]),
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
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
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
                  color: Colors.grey[200],
                  child: Icon(Icons.menu_book,
                      size: 100, color: Colors.grey[400]),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.book.authorFirst} ${widget.book.authorLast}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.book.publishedDate.year > 1)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Published: ${widget.book.publishedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (widget.book.genres.isNotEmpty) ...[
                    const Text(
                      'Genres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.book.genres.map((genre) {
                        return Chip(
                          label: Text(genre),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.book.synopsis.isNotEmpty) ...[
                    const Text(
                      'Synopsis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.book.synopsis,
                      style: const TextStyle(fontSize: 16, height: 1.5),
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
