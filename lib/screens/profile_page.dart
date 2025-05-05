import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../provider/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  void savePreferences(BuildContext context, bool isDark, String lang) async {
    final prefs = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    await prefs.set({'theme': isDark ? 'dark' : 'light', 'language': lang});
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          Text('Logged in as: ${user?.email}'),
          SwitchListTile(
            title: Text('Dark Theme'),
            value: isDark,
            onChanged: (val) {
              themeProvider.toggleTheme(val);
              savePreferences(context, val, themeProvider.language);
            },
          ),
          DropdownButton<String>(
            value: themeProvider.language,
            items: ['en', 'kk', 'ru']
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang.toUpperCase())))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                themeProvider.setLanguage(val);
                savePreferences(context, isDark, val);
              }
            },
          ),
          ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(), child: Text('Logout')),
        ],
      ),
    );
  }
}
