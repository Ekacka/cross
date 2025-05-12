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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(user.isAnonymous ? 'Guest' : user.email ?? 'No email'),
              subtitle: Text(user.isAnonymous ? 'Guest Mode' : 'Logged in'),
            ),
            ElevatedButton.icon(
              icon: Icon(user.isAnonymous ? Icons.login : Icons.logout),
              label: Text(user.isAnonymous ? "Login" : "Logout"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Optionally navigate to login screen if needed
                // Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.isAnonymous ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const Divider(),
          ],
          SwitchListTile(
            title: Text(AppLocalizations.of(context)?.darkTheme ?? 'Dark Theme'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) => themeProvider.toggleTheme(value),
          ),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)?.language ?? 'Language',
              style: Theme.of(context).textTheme.titleLarge),
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
        ],
      ),
    );
  }
}
