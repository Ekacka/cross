import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_page.dart';
import 'screens/login_page.dart';
import 'firebase_options.dart'; // Generate using `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ThemeProvider(), child: Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'App',
          theme: themeProvider.getTheme(),
          home: AuthWrapper(),
          localizationsDelegates: const [
            // Add localization delegates
          ],
          supportedLocales: const [Locale('en'), Locale('kk'), Locale('ru')],
        );
      },
    ));
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
