import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightThem() => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.deepPurpleAccent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.deepPurple,
        ),
      ),
    );
