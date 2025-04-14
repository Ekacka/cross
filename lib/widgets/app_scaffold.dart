import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final String? appBarTitle;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.floatingActionButton,
    this.showAppBar = false,
    this.appBarTitle,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/about');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
        title: Text(appBarTitle ?? local.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: local.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: local.about_app,
          ),
        ],
      ),
    );
  }
}
