import 'package:flutter/material.dart';
import '../screens/home_screen.dart'; // Make sure to import HomeScreen
import '../screens/settings_page.dart'; // Make sure to import SettingsPage
import '../screens/about_page.dart'; // Import the AboutPage

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutPage(), // Add AboutPage here
    const settings_page(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the screen based on the current index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index when a tab is clicked
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline), // Icon for About page
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
