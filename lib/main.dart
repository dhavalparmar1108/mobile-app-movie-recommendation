import 'package:flutter/material.dart';
import 'package:movie_recommendation/app_theme/themes.dart';
import 'package:movie_recommendation/constants/constants.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      themeMode: ThemeMode.dark,
      theme: AppThemes().lightTheme(),
      darkTheme: AppThemes().darkTheme(),
      home: const Home(),
    );
  }
}