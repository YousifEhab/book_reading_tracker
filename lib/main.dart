import 'package:book_reading_tracker/cubits/book_cubit.dart';
import 'package:book_reading_tracker/cubits/theme_cubit.dart';
import 'package:book_reading_tracker/models/book.dart';
import 'package:book_reading_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(ReadingStatusAdapter());
  
  await Hive.openBox<Book>('books');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BookCubit()..loadBooks()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Book Reading Tracker',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}