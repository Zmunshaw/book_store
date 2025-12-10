import 'package:flutter/material.dart';
import '../models/book.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  // Mock data - replace with API calls later
  final List<Book> _allBooks = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      authorFirst: 'F. Scott',
      authorLast: 'Fitzgerald',
      synopsis: 'A classic American novel set in the Jazz Age',
      publishedDate: DateTime(1925, 4, 10),
      coverImageUrl: '',
      genres: ['Fiction', 'Classic'],
    ),
    Book(
      id: '2',
      title: '1984',
      authorFirst: 'George',
      authorLast: 'Orwell',
      synopsis: 'A dystopian social science fiction novel',
      publishedDate: DateTime(1949, 6, 8),
      coverImageUrl: '',
      genres: ['Fiction', 'Dystopian'],
    ),
    Book(
      id: '3',
      title: 'To Kill a Mockingbird',
      authorFirst: 'Harper',
      authorLast: 'Lee',
      synopsis: 'A gripping tale of racial injustice and childhood innocence',
      publishedDate: DateTime(1960, 7, 11),
      coverImageUrl: '',
      genres: ['Fiction', 'Classic'],
    ),
    Book(
      id: '4',
      title: 'Dune',
      authorFirst: 'Frank',
      authorLast: 'Herbert',
      synopsis: 'Epic science fiction on the desert planet Arrakis',
      publishedDate: DateTime(1965, 8, 1),
      coverImageUrl: '',
      genres: ['Science Fiction'],
    ),
  ];

  List<Book> get _filteredBooks {
    var books = _allBooks;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      books = books.where((book) =>
        book.title.toLowerCase().contains(query) ||
        book.authorFirst.toLowerCase().contains(query) ||
        book.authorLast.toLowerCase().contains(query)
      ).toList();
    }

    if (_selectedFilter != 'All') {
      books = books.where((book) =>
        book.genres.contains(_selectedFilter)
      ).toList();
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Books'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
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
                  onChanged: (value) => setState(() {}),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('Fiction'),
                    _buildFilterChip('Classic'),
                    _buildFilterChip('Science Fiction'),
                    _buildFilterChip('Dystopian'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _filteredBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No books found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
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
          // Navigate to book details
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book, size: 40, color: Colors.grey[400]),
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
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.synopsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: book.genres.map((genre) => Chip(
                        label: Text(
                          genre,
                          style: const TextStyle(fontSize: 11),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
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
