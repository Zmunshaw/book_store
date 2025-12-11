import 'package:flutter/material.dart';
import '../../models/book.dart';

class BookInfoSection extends StatelessWidget {
  final Book book;

  const BookInfoSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF41),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '> by ${book.authorFirst} ${book.authorLast}'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF00D9FF),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          if (book.publishedDate.year > 1)
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF00FF41),
                ),
                const SizedBox(width: 8),
                Text(
                  '> PUBLISHED: ${book.publishedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00FF41),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (book.genres.isNotEmpty) ...[
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
              children: book.genres.map((genre) {
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
          if (book.synopsis.isNotEmpty) ...[
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
              book.synopsis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF00FF41),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
