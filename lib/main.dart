import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/homescreen.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(
        isDarkMode: themeMode == ThemeMode.dark,
        onThemeChanged: (isDarkMode) {
          ref.read(themeProvider.notifier).state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        },
      ),
    );
  }
}
