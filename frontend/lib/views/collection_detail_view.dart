import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/collection.dart';
import '../models/book.dart';
import '../services/collection_service.dart';
import '../utils/image_utils.dart';
import '../theme/app_colors.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _collection.name,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.textOnPrimary),
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
          Icon(
            Icons.collections_bookmark_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Collection is Empty',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add books to this collection from the Home tab',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
      color: AppColors.surface,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailView(book: book),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 105,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: book.coverImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: getAbsoluteImageUrl(book.coverImageUrl),
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          placeholderFadeInDuration: const Duration(milliseconds: 100),
                          placeholder: (context, url) => Container(
                            color: AppColors.cardBackground,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.auto_stories,
                              size: 35,
                              color: AppColors.primary.withValues(alpha: 0.4),
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.auto_stories,
                        size: 35,
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${book.authorFirst} ${book.authorLast}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (book.publishedDate != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${book.publishedDate!.year}',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Georgia',
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              'Remove Book',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Remove "${book.title}" from this collection?',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                color: AppColors.textSecondary,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontFamily: 'Georgia'),
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _removeBook(book);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: AppColors.textOnPrimary,
                                ),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(fontFamily: 'Georgia'),
                                ),
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
