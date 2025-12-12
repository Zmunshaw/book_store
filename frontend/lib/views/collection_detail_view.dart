import 'package:flutter/material.dart';
import '../models/collection.dart';
import '../models/book.dart';
import '../services/collection_service.dart';
import '../utils/image_utils.dart';
import 'book_detail_view.dart';

class CollectionDetailView extends StatefulWidget {
  final Collection collection;

  const CollectionDetailView({super.key, required this.collection});

  @override
  State<CollectionDetailView> createState() => _CollectionDetailViewState();
}

class _CollectionDetailViewState extends State<CollectionDetailView> {
  late Collection _collection;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _collection = widget.collection;
  }

  Future<void> _removeBook(Book book) async {
    setState(() => _isLoading = true);

    final result = await CollectionService.removeBookFromCollection(
      collectionId: _collection.id,
      bookId: book.id,
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (result['success']) {
        setState(() {
          _collection = Collection(
            id: _collection.id,
            name: _collection.name,
            imageURL: _collection.imageURL,
            userID: _collection.userID,
            books: _collection.books.where((b) => b.id != book.id).toList(),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book removed from collection')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to remove book'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_collection.name),
      ),
      body: _collection.books.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _collection.books.length,
              itemBuilder: (context, index) {
                return _buildBookCard(_collection.books[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No books in this collection',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add books from the Home tab',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailView(book: book),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[800],
                ),
                child: book.coverImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          getAbsoluteImageUrl(book.coverImageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.menu_book,
                                size: 30, color: Colors.grey[400]);
                          },
                        ),
                      )
                    : Icon(Icons.menu_book, size: 30, color: Colors.grey[400]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${book.authorFirst} ${book.authorLast}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    if (book.publishedDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Published: ${book.publishedDate!.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _isLoading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Book'),
                            content: Text(
                                'Remove "${book.title}" from this collection?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _removeBook(book);
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
