import 'package:book_reading_tracker/cubits/book_cubit.dart';
import 'package:book_reading_tracker/cubits/book_state.dart';
import 'package:book_reading_tracker/cubits/theme_cubit.dart';
import 'package:book_reading_tracker/models/book.dart';
import 'package:book_reading_tracker/screens/add_book_screen.dart';
import 'package:book_reading_tracker/screens/book_detail_screen.dart';
import 'package:book_reading_tracker/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Reading Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Books'),
            Tab(text: 'To Read'),
            Tab(text: 'Reading'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: BlocBuilder<BookCubit, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is BookError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          if (state is BookLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookList(state.books),
                _buildBookList(state.books.where((book) => book.status == ReadingStatus.toRead).toList()),
                _buildBookList(state.books.where((book) => book.status == ReadingStatus.reading).toList()),
                _buildBookList(state.books.where((book) => book.status == ReadingStatus.completed).toList()),
              ],
            );
          }
          
          return Center(child: Text('No books yet'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookList(List<Book> books) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          'No books in this category',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          book: book,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}