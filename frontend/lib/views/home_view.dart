import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/book.dart';
import '../services/book_api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
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
              title: Text(
                'BOOK STORE',
                style: AppTextStyles.headlineMedium.copyWith(
                  letterSpacing: AppDimensions.letterSpacingExtraLoose,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.background,
                      AppColors.surface,
                      AppColors.primaryWithOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.terminal,
                    size: AppDimensions.iconXxxl,
                    color: AppColors.primaryWithOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: AppDimensions.paddingL,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: '> search_query...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryWithOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.error,
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
                SizedBox(height: AppDimensions.spacingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery == 'bestseller' ? '> FEATURED_BOOKS' : '> SEARCH_RESULTS',
                      style: AppTextStyles.terminalHeader,
                    ),
                    if (!_isLoading)
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: AppColors.secondary,
                        ),
                        onPressed: _loadBooks,
                        tooltip: 'Refresh',
                      ),
                  ],
                ),
                SizedBox(height: AppDimensions.spacingL),
              ]),
            ),
          ),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppDimensions.iconXxxl,
                      color: AppColors.error,
                    ),
                    SizedBox(height: AppDimensions.spacingL),
                    Text(
                      _errorMessage!,
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppDimensions.spacingL),
                    ElevatedButton.icon(
                      onPressed: _loadBooks,
                      icon: const Icon(Icons.refresh),
                      label: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            )
          else if (_featuredBooks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  '> NO_BOOKS_FOUND',
                  style: AppTextStyles.headlineSmall.copyWith(
                    letterSpacing: AppDimensions.letterSpacingLoose,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: AppDimensions.paddingHorizontalL,
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: AppDimensions.spacingM,
                  mainAxisSpacing: AppDimensions.spacingM,
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
                padding: AppDimensions.paddingL,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          if (!_isLoading && !_hasMore && _featuredBooks.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: AppDimensions.paddingL,
                child: Center(
                  child: Text(
                    '> END_OF_DATA',
                    style: AppTextStyles.bodyMedium.copyWith(
                      letterSpacing: AppDimensions.letterSpacingLoose,
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
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
