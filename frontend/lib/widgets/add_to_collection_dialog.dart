import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/collection.dart';
import '../services/collection_service.dart';
import '../services/auth_service.dart';

class AddToCollectionDialog extends StatefulWidget {
  final Book book;

  const AddToCollectionDialog({super.key, required this.book});

  @override
  State<AddToCollectionDialog> createState() => _AddToCollectionDialogState();
}

class _AddToCollectionDialogState extends State<AddToCollectionDialog> {
  List<Collection> _collections = [];
  bool _isLoading = true;
  bool _isAdding = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    if (!AuthService.isLoggedIn()) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please log in to add books to collections';
      });
      return;
    }

    final result = await CollectionService.getUserCollections();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _collections = result['collections'] as List<Collection>;
          if (_collections.isEmpty) {
            _errorMessage = 'No collections found. Create one first!';
          }
        } else {
          _errorMessage = result['error'] ?? 'Failed to load collections';
        }
      });
    }
  }

  Future<void> _addToCollection(Collection collection) async {
    setState(() => _isAdding = true);

    final result = await CollectionService.addBookToCollection(
      collectionId: collection.id,
      book: widget.book,
    );

    if (mounted) {
      setState(() => _isAdding = false);

      if (result['success']) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to "${collection.name}"'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to add book'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add to Collection',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.book.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[400],
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _collections.length,
      itemBuilder: (context, index) {
        final collection = _collections[index];
        final alreadyInCollection = collection.books.any((b) => b.id == widget.book.id);

        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.collections_bookmark,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(collection.name),
          subtitle: Text('${collection.books.length} books'),
          trailing: alreadyInCollection
              ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
              : const Icon(Icons.add),
          enabled: !_isAdding && !alreadyInCollection,
          onTap: alreadyInCollection
              ? null
              : () => _addToCollection(collection),
        );
      },
    );
  }
}
