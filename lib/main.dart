import 'package:flutter/material.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/provider/user_review_provider.dart';
import 'package:movie_review_app/presentation/provider/watchlist_provider.dart';
import 'package:movie_review_app/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => UserReviewProvider()),
      ],
      child: MaterialApp(
        title: 'Movie Review App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF002335)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}