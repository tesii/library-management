import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define StateProviders
final sortingProvider = StateProvider<String>((ref) => 'title');
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Define ServiceProvider for accessing settings
final settingsServiceProvider = Provider<SettingsService>((ref) => SettingsService(ref));

class SettingsService {
  final ProviderRef ref;

  SettingsService(this.ref);

  Future<void> setSortingPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sorting_preference', value);
  }

  Future<String?> getSortingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sorting_preference') ?? 'title';
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString('theme_mode');
    return modeString == ThemeMode.dark.toString() ? ThemeMode.dark : ThemeMode.light;
  }
}
