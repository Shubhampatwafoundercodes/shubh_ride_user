import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recentPlacesProvider =
StateNotifierProvider<RecentPlacesNotifier, List<Map<String, dynamic>>>((ref) {
  return RecentPlacesNotifier()..load();
});

class RecentPlacesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  RecentPlacesNotifier() : super([]);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_places') ?? [];
    final decoded = list.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    state = decoded;
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'recent_places',
      state.map((e) => jsonEncode(e)).toList(),
    );
  }

  Future<void> addRecent(Map<String, dynamic> place) async {
    final cleanPlace = {
      "title": place["title"] ?? place["mainText"] ?? "",
      "subtitle": place["subtitle"] ?? place["secondaryText"] ?? "",
      "placeId": place["placeId"],
      "lat": place["lat"],
      "lng": place["lng"],
      "isFav": place["isFav"] ?? false,
      "type": place["type"],
      "icon": place["icon"],
    };

    final filtered = state.where((p) =>
    p["placeId"] != cleanPlace["placeId"] &&
        (p["title"] != cleanPlace["title"] || p["subtitle"] != cleanPlace["subtitle"])).toList();

    filtered.insert(0, cleanPlace);
    final limited = filtered.take(6).toList();

    state = limited;
    await _saveToPrefs();
  }

  Future<void> markFavourite(String type, Map<String, dynamic> place, {String? icon}) async {
    final updated = state.map((p) {
      if (p["type"] == type) {
        return {...p, "isFav": false, "type": null, "icon": null};
      }
      if (p["title"] == place["title"] && p["subtitle"] == place["subtitle"]) {
        return {...p, "isFav": true, "type": type, "icon": icon};
      }
      return p;
    }).toList();

    state = updated;
    await _saveToPrefs();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_places');
    state = [];
  }
}
