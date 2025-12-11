import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/collection.dart';
import '../services/collection_service.dart';
import '../services/auth_service.dart';
import 'book_detail_view.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Book> _allBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _loadBooks() async {
    if (!AuthService.isLoggedIn()) {
      setState(() {
        _allBooks = [];
        _errorMessage = 'Please log in to view your books';
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
          final collections = result['collections'] as List<Collection>;
          // Extract all unique books from all collections
          final booksSet = <String, Book>{};
          for (final collection in collections) {
            for (final book in collection.books) {
              booksSet[book.id] = book;
            }
          }
          _allBooks = booksSet.values.toList();
        } else {
          _errorMessage = result['error'] ?? 'Failed to load books';
        }
      });
    }
  }

  List<Book> get _filteredBooks {
    var books = _allBooks;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      books = books
          .where((book) =>
              book.title.toLowerCase().contains(query) ||
              book.authorFirst.toLowerCase().contains(query) ||
              book.authorLast.toLowerCase().contains(query))
          .toList();
    }

    if (_selectedFilter != 'All') {
      books =
          books.where((book) => book.genres.contains(_selectedFilter)).toList();
    }

    return books;
  }

  Set<String> get _availableGenres {
    final genres = <String>{};
    for (final book in _allBooks) {
      genres.addAll(book.genres);
    }
    return genres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBooks,
            tooltip: 'Refresh',
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
            ElevatedButton(
              onPressed: _loadBooks,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        if (_availableGenres.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All'),
                ..._availableGenres.map((genre) => _buildFilterChip(genre)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_outlined,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _allBooks.isEmpty
                            ? 'No books yet'
                            : 'No books found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      if (_allBooks.isEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Add books to collections from the Home tab',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredBooks.length,
                  itemBuilder: (context, index) {
                    return _buildBookListItem(_filteredBooks[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
      ),
    );
  }

  Widget _buildBookListItem(Book book) {
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
                          book.coverImageUrl,
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
                    if (book.genres.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: book.genres
                            .map((genre) => Chip(
                                  label: Text(
                                    genre,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
