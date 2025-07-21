import 'package:book_reading_tracker/cubits/book_cubit.dart';
import 'package:book_reading_tracker/models/book.dart';
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
    _pageController = TextEditingController(text: widget.book.currentPage.toString());
    _notesController = TextEditingController(text: widget.book.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
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
                        widget.book.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'by ${widget.book.author}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: widget.book.progressPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${widget.book.currentPage} / ${widget.book.totalPages} pages (${widget.book.progressPercentage.toStringAsFixed(1)}%)',
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
                        'Status: ${_getStatusText(widget.book.status)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      DropdownButton<ReadingStatus>(
                        value: widget.book.status,
                        isExpanded: true,
                        items: ReadingStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(_getStatusText(status)),
                          );
                        }).toList(),
                        onChanged: (ReadingStatus? newStatus) {
                          if (newStatus != null) {
                            context.read<BookCubit>().changeBookStatus(widget.book.id, newStatus);
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          final currentPage = int.tryParse(_pageController.text) ?? 0;
                          if (currentPage <= widget.book.totalPages) {
                            context.read<BookCubit>().updateReadingProgress(widget.book.id, currentPage);
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          final updatedBook = widget.book.copyWith(
                            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
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
  }

  String _getStatusText(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.toRead:
        return 'To Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.completed:
        return 'Completed';
      case ReadingStatus.abandoned:
        return 'Abandoned';
    }
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