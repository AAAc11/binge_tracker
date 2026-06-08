import 'package:flutter/material.dart';
import 'package:projekt_zaliczeniowy/watchlist_screen.dart';
import 'home_screen.dart';
import 'add_show_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  //lista ekranów
  final List<Widget> _screens = [
    const HomeScreen(),
    const WatchlistScreen(),
    AddShowScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Odkrywaj"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Watchlista"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Dodaj"),
        ],
      ),
    );
  }
}