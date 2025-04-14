import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Widget? floatingActionButton; // Add floatingActionButton parameter

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.floatingActionButton, // Add floatingActionButton in the constructor
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/about');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: floatingActionButton, // Pass the floatingActionButton
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
