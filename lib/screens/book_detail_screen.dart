import 'package:book_reading_tracker/cubits/book_cubit.dart';
import 'package:book_reading_tracker/cubits/book_state.dart';
import 'package:book_reading_tracker/models/book.dart';
import 'package:book_reading_tracker/utils/book_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late TextEditingController _pageController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(
      text: widget.book.currentPage.toString(),
    );
    _notesController = TextEditingController(text: widget.book.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        Book currentBook = widget.book;

        if (state is BookLoaded) {
          final updatedBook = state.books.firstWhere(
            (book) => book.id == widget.book.id,
            orElse: () => widget.book,
          );
          currentBook = updatedBook;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(currentBook.title),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog();
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentBook.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'by ${currentBook.author}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: currentBook.progressPercentage / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              BookUtils.getStatusColor(currentBook.status),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${currentBook.currentPage} / ${currentBook.totalPages} pages (${currentBook.progressPercentage.toStringAsFixed(1)}%)',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${BookUtils.getStatusText(currentBook.status)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          DropdownButton<ReadingStatus>(
                            value: currentBook.status,
                            isExpanded: true,
                            items: ReadingStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(BookUtils.getStatusText(status)),
                              );
                            }).toList(),
                            onChanged: (ReadingStatus? newStatus) {
                              if (newStatus != null) {
                                context.read<BookCubit>().changeBookStatus(
                                  currentBook.id,
                                  newStatus,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _pageController,
                            decoration: InputDecoration(
                              labelText: 'Current Page',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final currentPage =
                                  int.tryParse(_pageController.text) ?? 0;
                              if (currentPage <= currentBook.totalPages) {
                                context.read<BookCubit>().updateReadingProgress(
                                  currentBook.id,
                                  currentPage,
                                );
                              }
                            },
                            child: Text('Update Progress'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              labelText: 'Book Notes',
                              border: OutlineInputBorder(),
                              hintText: 'Add your thoughts about this book...',
                            ),
                            maxLines: 4,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final updatedBook = currentBook.copyWith(
                                notes: _notesController.text.isNotEmpty
                                    ? _notesController.text
                                    : null,
                              );
                              context.read<BookCubit>().updateBook(updatedBook);
                            },
                            child: Text('Save Notes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Book'),
        content: Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookCubit>().deleteBook(widget.book.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
