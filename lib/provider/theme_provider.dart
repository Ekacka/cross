import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  final _dbRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  ThemeProvider() {
    _loadUserSettings();
  }

  void _loadUserSettings() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        final snapshot = await _dbRef.child('users/${user.uid}/settings').get();
        final data = snapshot.value as Map?;
        if (data != null) {
          if (data['theme'] == 'dark') {
            _themeMode = ThemeMode.dark;
          } else {
            _themeMode = ThemeMode.light;
          }
          if (data['language'] != null) {
            _locale = Locale(data['language']);
          }
          notifyListeners();
        }
      }
    });
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveSettings();
  }

  void changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _dbRef.child('users/${user.uid}/settings').set({
        'theme': _themeMode == ThemeMode.dark ? 'dark' : 'light',
        'language': _locale.languageCode,
      });
    }
  }
}
