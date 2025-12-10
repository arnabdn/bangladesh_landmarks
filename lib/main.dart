import 'package:flutter/material.dart';
import 'screens/overview_map.dart';
import 'screens/records_list.dart';
import 'screens/new_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  final pages = const [
    OverviewMapScreen(),
    RecordsListScreen(),
    NewEntryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006EAF),
          primary: const Color(0xFF006EAF),
          secondary: const Color(0xFFFFA726),
          tertiary: const Color(0xFF26A69A),
        ),

        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor: Colors.black26,
          backgroundColor: Color(0xFF006EAF),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF006EAF),
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedIconTheme: IconThemeData(size: 24),
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006EAF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 4,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF006EAF), width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade700),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFF006EAF),
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF006EAF),
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),

      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) => setState(() => index = value),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Overview"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Records"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "New Entry"),
          ],
        ),
      ),
    );
  }
}

