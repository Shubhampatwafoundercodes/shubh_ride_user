import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key
const _localeKey = 'locale';

/// Supported languages list

final supportedLanguages = [
  {"code": "en", "name": "English"},
  {"code": "hi", "name": "हिन्दी"},
  // {"code": "mr", "name": "मराठी"},
];



/// Locale Notifier (with SharedPreferences persistence)
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? 'en';
    state = Locale(code);
  }

  /// Change locale + save it
  Future<void> changeLocale(String code) async {
    state = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
  }

  /// Get all available language names (for dropdown)
  List<String> get languageNames =>
      supportedLanguages.map((e) => e["name"] as String).toList();

  /// Get language name from current locale
  String get currentLanguageName =>
      supportedLanguages
          .firstWhere((lang) => lang["code"] == state.languageCode)["name"]
      as String;

  /// Get code from language name
  String getCodeFromName(String name) =>
      supportedLanguages.firstWhere((lang) => lang["name"] == name)["code"] as String;
}

/// Exposed provider (Locale)
final localeProvider =
StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

/// Helper provider → selected language name
final currentLanguageProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  final notifier = ref.read(localeProvider.notifier);
  return notifier.currentLanguageName;
});

/// Helper provider → available languages
final availableLanguagesProvider = Provider<List<String>>((ref) {
  final notifier = ref.read(localeProvider.notifier);
  return notifier.languageNames;
});


