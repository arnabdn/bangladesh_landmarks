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
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0066CC),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black26,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),

        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0066CC),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),

      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) => setState(() => index = value),
          selectedItemColor: const Color(0xFF0066CC),
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

