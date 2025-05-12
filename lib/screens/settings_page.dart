import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class settings_page extends StatelessWidget {
  const settings_page({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(isGuest ? 'Guest' : user.email ?? 'No email'),
              subtitle: Text(isGuest ? 'Guest Mode' : 'Logged in'),
            ),
            ElevatedButton.icon(
              icon: Icon(isGuest ? Icons.login : Icons.logout),
              label: Text(isGuest ? "Login" : "Logout"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Optional: Navigate to login screen
                // Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isGuest ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const Divider(),
          ],

          // Theme toggle
          SwitchListTile(
            title: Text(AppLocalizations.of(context)?.darkTheme ?? 'Dark Theme'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) => themeProvider.toggleTheme(value),
          ),
          if (isGuest)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                "Theme changes won't be saved in guest mode. Login to save preferences.",
                style: TextStyle(color: Colors.orange),
              ),
            ),

          const SizedBox(height: 24),

          // Language dropdown
          Text(
            AppLocalizations.of(context)?.language ?? 'Language',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: themeProvider.locale.languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'kk', child: Text('Kazakh')),
              DropdownMenuItem(value: 'ru', child: Text('Russian')),
            ],
            onChanged: (value) {
              if (value != null) {
                themeProvider.changeLanguage(value);
              }
            },
          ),
          if (isGuest)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                "Language preference won't be saved in guest mode. Login to save preferences.",
                style: TextStyle(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}
