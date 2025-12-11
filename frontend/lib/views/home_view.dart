import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import '../widgets/book/book_card.dart';
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
  final TextEditingController _searchController = TextEditingController();

  List<Book> _featuredBooks = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  String _searchQuery = 'bestseller';

  @override
  void initState() {
    super.initState();
    _logger.i('HomeView initialized');
    _loadBooks();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

  Future<void> _loadBooks({String? query}) async {
    final searchQuery = query ?? _searchQuery;
    _logger.i('Loading books with query: $searchQuery');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = 1;
      _featuredBooks = [];
      _hasMore = true;
      _searchQuery = searchQuery;
    });

    try {
      final books = await _apiService.searchBooks(searchQuery, page: 1);
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
      final books = await _apiService.searchBooks(_searchQuery, page: _currentPage + 1);
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

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    _logger.i('Search submitted: $query');
    _loadBooks(query: query.trim());
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
              title: const Text(
                'BOOK STORE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF010409),
                      const Color(0xFF0D1117),
                      const Color(0xFF00FF41).withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.terminal,
                    size: 80,
                    color: const Color(0xFF00FF41).withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Color(0xFF00FF41)),
                  decoration: InputDecoration(
                    hintText: '> search_query...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF00FF41).withValues(alpha: 0.4),
                      fontFamily: 'monospace',
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF00FF41),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFFFF0055),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _loadBooks(query: 'bestseller');
                            },
                          )
                        : null,
                  ),
                  onSubmitted: _onSearchSubmitted,
                  textInputAction: TextInputAction.search,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery == 'bestseller' ? '> FEATURED_BOOKS' : '> SEARCH_RESULTS',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FF41),
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (!_isLoading)
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFF00D9FF),
                        ),
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
                child: CircularProgressIndicator(
                  color: Color(0xFF00FF41),
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Color(0xFFFF0055),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF00FF41),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadBooks,
                      icon: const Icon(Icons.refresh),
                      label: const Text('RETRY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D1117),
                        foregroundColor: const Color(0xFF00FF41),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_featuredBooks.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  '> NO_BOOKS_FOUND',
                  style: TextStyle(
                    color: Color(0xFF00FF41),
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
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
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00D9FF),
                  ),
                ),
              ),
            ),
          if (!_isLoading && !_hasMore && _featuredBooks.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '> END_OF_DATA',
                    style: TextStyle(
                      color: Color(0xFF00FF41),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return BookCard(
      book: book,
      onTap: () {
        _logger.i('Opening book details: ${book.title}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailView(book: book),
          ),
        );
      },
      onAddPressed: () {
        _logger.i('Add button pressed for: ${book.title}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${book.title}" to collection'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF00FF41),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
