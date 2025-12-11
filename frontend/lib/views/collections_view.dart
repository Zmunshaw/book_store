import 'package:flutter/material.dart';
import '../models/collection.dart';
import '../services/collection_service.dart';
import '../services/auth_service.dart';
import 'collection_detail_view.dart';

class CollectionsView extends StatefulWidget {
  const CollectionsView({super.key});

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  List<Collection> _collections = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    if (!AuthService.isLoggedIn()) {
      setState(() {
        _collections = [];
        _errorMessage = 'Please log in to view your collections';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await CollectionService.getUserCollections();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _collections = result['collections'] as List<Collection>;
        } else {
          _errorMessage = result['error'] ?? 'Failed to load collections';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCollections,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: AuthService.isLoggedIn() ? _showAddCollectionDialog : null,
            tooltip: 'Create Collection',
          ),
        ],
      ),
      body: _buildBody(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (!AuthService.isLoggedIn())
              ElevatedButton(
                onPressed: () {
                  // User can navigate to login tab manually
                },
                child: const Text('Go to Login'),
              )
            else
              ElevatedButton(
                onPressed: _loadCollections,
                child: const Text('Retry'),
              ),
          ],
        ),
      );
    }

    if (_collections.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _collections.length,
      itemBuilder: (context, index) {
        return _buildCollectionCard(_collections[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_bookmark_outlined,
              size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No collections yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _showAddCollectionDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create your first collection'),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(Collection collection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CollectionDetailView(collection: collection),
            ),
          ).then((_) => _loadCollections());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.collections_bookmark,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collection.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${collection.books.length} books',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showOptionsMenu(collection);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(Collection collection) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Collection'),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteCollection(collection);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteCollection(Collection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text('Are you sure you want to delete "${collection.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteCollection(collection.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCollection(String collectionId) async {
    final result = await CollectionService.deleteCollection(
      collectionId: collectionId,
    );

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Collection deleted')),
        );
        _loadCollections();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to delete collection'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddCollectionDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Collection'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Collection Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }

              Navigator.pop(context);

              final result = await CollectionService.createCollection(
                name: name,
              );

              if (mounted) {
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Collection created')),
                  );
                  _loadCollections();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          result['error'] ?? 'Failed to create collection'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
