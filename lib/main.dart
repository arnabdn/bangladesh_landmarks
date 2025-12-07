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

