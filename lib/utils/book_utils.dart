import 'package:flutter/material.dart';
import 'package:book_reading_tracker/models/book.dart';

class BookUtils {
  static String getStatusText(ReadingStatus status) {
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

  static Color getStatusColor(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.toRead:
        return Colors.grey;
      case ReadingStatus.reading:
        return Colors.blue;
      case ReadingStatus.completed:
        return Colors.green;
      case ReadingStatus.abandoned:
        return Colors.red;
    }
  }
}
