import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/app_scaffold.dart';
import 'provider/theme_provider.dart';
import 'themes.dart'; // define lightTheme and darkTheme

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Smart Shopping List',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      locale: themeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('kk'),
        Locale('ru'),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const AppScaffold(),
    );
  }
}
