import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
enum ReadingStatus {
  @HiveField(0)
  toRead,
  @HiveField(1)
  reading,
  @HiveField(2)
  completed,
  @HiveField(3)
  abandoned,
}

@HiveType(typeId: 1)
class Book {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String author;
  
  @HiveField(3)
  final int totalPages;
  
  @HiveField(4)
  final int currentPage;
  
  @HiveField(5)
  final ReadingStatus status;
  
  @HiveField(6)
  final DateTime dateAdded;
  
  @HiveField(7)
  final DateTime? dateStarted;
  
  @HiveField(8)
  final DateTime? dateCompleted;
  
  @HiveField(9)
  final String? notes;
  
  @HiveField(10)
  final int? rating;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.totalPages,
    this.currentPage = 0,
    this.status = ReadingStatus.toRead,
    required this.dateAdded,
    this.dateStarted,
    this.dateCompleted,
    this.notes,
    this.rating,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    int? totalPages,
    int? currentPage,
    ReadingStatus? status,
    DateTime? dateAdded,
    DateTime? dateStarted,
    DateTime? dateCompleted,
    String? notes,
    int? rating,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      dateAdded: dateAdded ?? this.dateAdded,
      dateStarted: dateStarted ?? this.dateStarted,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
    );
  }

  double get progressPercentage => 
      totalPages > 0 ? (currentPage / totalPages) * 100 : 0;
}