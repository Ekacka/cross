import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About the App', style: theme.headlineLarge),
                    const SizedBox(height: 12),
                    Text(
                      'This Shopping List app helps users efficiently create and manage their shopping lists. '
                          'Users can add items they need to buy, mark items as purchased, and stay organized while shopping. '
                          'The simple and intuitive interface ensures a smooth experience in tracking shopping needs without hassle.',
                      style: theme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Credits', style: theme.titleLarge),
                    const SizedBox(height: 12),
                    Text(
                      'Developed by Yesbossynov Sanzhar and Kuanysh Bekzhan in the scope of the course '
                          '“Crossplatform Development” at Astana IT University.\n\n'
                          'Mentor: Assistant Professor Abzal Kyzyrkanov',
                      style: theme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Go to Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
