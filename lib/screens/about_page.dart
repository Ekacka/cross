import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return AppScaffold(
      currentIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization?.about_app ?? 'About the App',
                      style: textTheme.headlineLarge?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization?.about_app_description ?? 'Description not available.',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
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
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization?.credits ?? 'Credits',
                      style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization?.credits_description ?? 'Credits description not available.',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
