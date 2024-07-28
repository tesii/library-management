import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/DatabaseHelper.dart';

final bookListProvider = StateNotifierProvider<BookListNotifier, List<Book>>((ref) {
  return BookListNotifier();
});

class BookListNotifier extends StateNotifier<List<Book>> {
  BookListNotifier() : super([]);

  Future<void> loadBooks() async {
    state = await DatabaseHelper().getBooks();
  }

  void addBook(Book book) {
    state = [...state, book];
  }

  void updateBook(Book book) {
    state = [
      for (final b in state)
        if (b.id == book.id) book else b
    ];
  }

  void deleteBook(int id) {
    state = state.where((book) => book.id != id).toList();
  }

  void sortBooks(String sortingPreference) {
    state = [...state];
    if (sortingPreference == 'title') {
      state.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortingPreference == 'author') {
      state.sort((a, b) => a.author.compareTo(b.author));
    } else if (sortingPreference == 'rating') {
      state.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  void toggleIsRead(int id) {
    state = [
      for (final book in state)
        if (book.id == id)
          Book(
            id: book.id,
            title: book.title,
            author: book.author,
            rating: book.rating,
            isRead: !book.isRead,
          )
        else
          book
    ];
  }
}
