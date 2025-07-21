import 'package:book_reading_tracker/cubits/book_state.dart';
import 'package:book_reading_tracker/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';


class BookCubit extends Cubit<BookState> {
  static const String _boxName = 'books';
  
  Box<Book> get _box => Hive.box<Book>(_boxName);

  BookCubit() : super(BookInitial());

  void loadBooks() {
    emit(BookLoading());
    try {
      final books = _box.values.toList();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _box.put(book.id, book);
      loadBooks();
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _box.put(book.id, book);
      loadBooks();
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _box.delete(id);
      loadBooks();
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> updateReadingProgress(String id, int currentPage) async {
    try {
      final book = _box.get(id);
      if (book != null) {
        final updatedBook = book.copyWith(
          currentPage: currentPage,
          status: currentPage >= book.totalPages 
              ? ReadingStatus.completed 
              : ReadingStatus.reading,
          dateCompleted: currentPage >= book.totalPages 
              ? DateTime.now() 
              : null,
        );
        await _box.put(id, updatedBook);
        loadBooks();
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> changeBookStatus(String id, ReadingStatus status) async {
    try {
      final book = _box.get(id);
      if (book != null) {
        final updatedBook = book.copyWith(
          status: status,
          dateStarted: status == ReadingStatus.reading && book.dateStarted == null
              ? DateTime.now()
              : book.dateStarted,
          dateCompleted: status == ReadingStatus.completed
              ? DateTime.now()
              : null,
        );
        await _box.put(id, updatedBook);
        loadBooks();
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}