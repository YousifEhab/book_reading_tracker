import 'package:book_reading_tracker/models/book.dart';
import 'package:book_reading_tracker/utils/book_utils.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'by ${book.author}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: book.progressPercentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  BookUtils.getStatusColor(book.status),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${book.currentPage} / ${book.totalPages} pages',
                    style: TextStyle(fontSize: 14),
                  ),
                  Chip(
                    label: Text(
                      BookUtils.getStatusText(book.status),
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: BookUtils.getStatusColor(book.status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
