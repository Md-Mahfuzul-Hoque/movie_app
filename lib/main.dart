import 'package:flutter/material.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
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