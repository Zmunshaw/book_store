import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import 'book_detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BookApiService _apiService = BookApiService();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );
  final ScrollController _scrollController = ScrollController();

  List<Book> _featuredBooks = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _logger.i('HomeView initialized');
    _loadBooks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _loadMoreBooks();
      }
    }
  }

  Future<void> _loadBooks() async {
    _logger.i('Loading books...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = 1;
      _featuredBooks = [];
      _hasMore = true;
    });

    try {
      final books = await _apiService.searchBooks('bestseller', page: 1);
      _logger.i('Books loaded successfully: ${books.length} books');
      setState(() {
        _featuredBooks = books;
        _isLoading = false;
        _hasMore = books.isNotEmpty;
      });
    } catch (e) {
      _logger.e('Failed to load books', error: e);
      setState(() {
        _errorMessage = 'Failed to load books. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreBooks() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    _logger.i('Loading more books... page ${_currentPage + 1}');

    try {
      final books = await _apiService.searchBooks('bestseller', page: _currentPage + 1);
      _logger.i('Loaded ${books.length} more books');

      setState(() {
        _currentPage++;
        _featuredBooks.addAll(books);
        _isLoadingMore = false;
        _hasMore = books.isNotEmpty;
      });
    } catch (e) {
      _logger.e('Failed to load more books', error: e);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Book Store'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.book, size: 80, color: Colors.white70),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Books',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    if (!_isLoading)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadBooks,
                        tooltip: 'Refresh',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
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
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadBooks,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_featuredBooks.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No books found'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = _featuredBooks[index];
                    return _buildBookCard(book);
                  },
                  childCount: _featuredBooks.length,
                ),
              ),
            ),
          if (_isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (!_isLoading && !_hasMore && _featuredBooks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No more books to load',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          _logger.i('Opening book details: ${book.title}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailView(book: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                child: book.coverImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        child: Image.network(
                          book.coverImageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.menu_book,
                                  size: 60, color: Colors.grey[400]),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(Icons.menu_book,
                            size: 60, color: Colors.grey[400]),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${book.authorFirst} ${book.authorLast}',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
