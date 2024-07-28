import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortingPreference = ref.watch(sortingProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple.shade50, // Set background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sorting Preference',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 10),
            _buildSortingOption(
              context: context,
              ref: ref,
              title: 'Title',
              value: 'title',
              groupValue: sortingPreference,
            ),
            _buildSortingOption(
              context: context,
              ref: ref,
              title: 'Author',
              value: 'author',
              groupValue: sortingPreference,
            ),
            _buildSortingOption(
              context: context,
              ref: ref,
              title: 'Rating',
              value: 'rating',
              groupValue: sortingPreference,
            ),
            SizedBox(height: 20),
            Text(
              'Theme Mode',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 10),
            _buildThemeOption(
              context: context,
              ref: ref,
              title: 'Light Mode',
              value: ThemeMode.light,
              groupValue: themeMode,
              icon: Icons.wb_sunny,
            ),
            _buildThemeOption(
              context: context,
              ref: ref,
              title: 'Dark Mode',
              value: ThemeMode.dark,
              groupValue: themeMode,
              icon: Icons.nights_stay,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final sortingPreference = ref.read(sortingProvider);
                  final themeMode = ref.read(themeProvider);

                  // Save preferences to SharedPreferences
                  await ref.read(settingsServiceProvider).setSortingPreference(sortingPreference);
                  await ref.read(settingsServiceProvider).setThemeMode(themeMode);

                  // Optionally show a SnackBar confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preferences saved!')),
                  );

                  // Go back to previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String value,
    required String groupValue,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.deepPurple),
      ),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          if (value != null) {
            ref.read(sortingProvider.notifier).state = value;
          }
        },
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required ThemeMode value,
    required ThemeMode groupValue,
    required IconData icon,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.deepPurple),
      ),
      leading: Icon(icon, color: Colors.deepPurple),
      trailing: Radio<ThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          if (value != null) {
            ref.read(themeProvider.notifier).state = value;
          }
        },
      ),
    );
  }
}
