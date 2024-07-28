import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the RatingBar package
import 'edit_book_screen.dart';
import '../models/book.dart';
import '../services/DatabaseHelper.dart';
import 'SettingsScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'BookSearchDelegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  HomeScreen({required this.isDarkMode, required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Book> _books = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _selectedSortCriteria = 'title';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    List<Book> books;
    if (_searchQuery.isEmpty) {
      final sortingPreference = ref.read(sortingProvider);
      books = await _databaseHelper.getBooks(sortBy: sortingPreference);
    } else {
      books = await _databaseHelper.searchBooksByName(_searchQuery);
    }

    setState(() {
      _books = books;
      print('Loaded books: ${_books.length}'); // Debug print
    });
  }

  void _sortBooks(String criteria) {
    setState(() {
      _selectedSortCriteria = criteria;
      ref.read(sortingProvider.notifier).state = criteria; // Update provider
      _loadBooks();
    });
  }

  void _addOrEditBook(Book? book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBookScreen(book: book)),
    );

    if (result != null) {
      if (book == null) {
        await _databaseHelper.insertBook(result);
      } else {
        await _databaseHelper.updateBook(result);
      }
      _loadBooks(); // Refresh the list after saving
    }
  }

  void _deleteBook(Book book) async {
    await _databaseHelper.deleteBook(book.id!);
    _loadBooks(); // Refresh the list after deleting
  }

  void _toggleIsRead(Book book) async {
    final updatedBook = Book(
      id: book.id,
      title: book.title,
      author: book.author,
      rating: book.rating,
      isRead: !book.isRead, // Toggle boolean value
    );
    await _databaseHelper.updateBook(updatedBook);
    _loadBooks(); // Refresh the list after toggling
  }

  void _toggleTheme() {
    widget.onThemeChanged(!widget.isDarkMode);
  }

  Color _generatePaleGold() {
    return Color(0xFFE6BE8A); // Light brown color
  }

  @override
  Widget build(BuildContext context) {
    final sortingPreference = ref.watch(sortingProvider); // Get current sorting preference

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(
                  onSearchQueryChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                    _loadBooks(); // Refresh the list when search query changes
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ).then((_) {
                // Reload books if settings were changed
                _loadBooks();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addOrEditBook(null),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/libraries.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Get Free Books!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Discover and manage your personal book collection. Add new books, edit existing ones, and keep track of your reading progress.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              // Book list
              Expanded(
                child: _books.isEmpty
                    ? Center(child: Text('No books found.'))
                    : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    final containerColor = _generatePaleGold(); // Light brown color for each book
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: containerColor, // Set the background color for the book container
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60, // Increased height for book cover
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // Placeholder color if no image
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  book.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple, // Set title color to purple
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author: ${book.author}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold, // Make the author bold
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Rating: ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                      ),
                                      RatingBar.builder(
                                        initialRating: book.rating.toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemSize: 20,
                                        onRatingUpdate: (rating) {
                                          // Handle rating update if needed
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Read: ${book.isRead ? 'Yes' : 'No'}',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                      ),
                                      Switch(
                                        value: book.isRead,
                                        onChanged: (value) => _toggleIsRead(book),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _addOrEditBook(book),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteBook(book),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
