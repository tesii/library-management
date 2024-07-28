import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<String?> getSortingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sortingPreference');
  }

  Future<void> saveSortingPreference(String sortingPreference) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortingPreference', sortingPreference);
  }

  Future<bool?> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode');
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
