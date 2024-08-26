import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes
{
  ThemeData lightTheme()
  {
    return ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme:  ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.indigo,
          primaryContainer: Colors.white
        ),
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(
            color: Colors.blueGrey
          ),
          unselectedIconTheme: IconThemeData(
              color: Colors.blueGrey
          ),
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.blueGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17
            ),
            backgroundColor: const Color(0xff34c3eb),
            side: const BorderSide(
                width: 1
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          hintStyle: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.black
              )
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.blue,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.indigo,
          // shape: RoundedRectangleBorder(
          //   side: const BorderSide(width: 0),
          //   borderRadius: BorderRadius.circular(10),
          // ),
        ),
        cardTheme: CardTheme(
          color: Colors.blueGrey,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(8)
          ),
        ),
        textTheme: TextTheme(
            displayLarge : GoogleFonts.poppins(color: Colors.white, fontSize: 20),
            bodyMedium: const TextStyle(color: Colors.black , fontSize: 16),
        )
    );
  }

  ThemeData darkTheme()
  {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme:  ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurpleAccent,
          primaryContainer: Colors.black
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 17
            ),
            backgroundColor: Colors.indigoAccent,
            side: const BorderSide(
                width: 1
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        appBarTheme: const AppBarTheme(
            //backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0
        ),
        inputDecorationTheme: const InputDecorationTheme(
          //fillColor: ColorConstants.darkModeThemeColor,
          labelStyle: TextStyle(
              color: Colors.grey
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.orange
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white
        ),
        cardTheme: CardTheme(
          color: Colors.blueGrey,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.orange
              ),
              borderRadius: BorderRadius.circular(8)
          ),
        ),
        textTheme: const TextTheme(
            bodyText2: TextStyle(color: Colors.white)
        )
    );
  }
}