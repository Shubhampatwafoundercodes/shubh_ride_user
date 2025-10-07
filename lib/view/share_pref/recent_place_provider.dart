import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

final recentPlacesProvider = StateNotifierProvider<RecentPlacesNotifier, List<dynamic>>((ref){
  return RecentPlacesNotifier();
});

class RecentPlacesNotifier extends StateNotifier<List<dynamic>>{
  RecentPlacesNotifier(): super([]);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_places') ?? [];
    state = list.map((e) => jsonDecode(e)).toList();
  }

  Future<void> addRecent(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();

    // Duplicate remove
    state.removeWhere((p) => p["title"] == place["title"] && p["subtitle"] == place["subtitle"]);

    // Add as recent default isFav=false
    state.insert(0, {...place, "isFav": false, "type": null, "icon": null});

    // Keep only 3
    if (state.length > 5) state.removeLast();

    await prefs.setStringList('recent_places', state.map((e) => jsonEncode(e)).toList());
    state = [...state]; // notify
  }

  Future<void> markFavourite(String type, Map<String, dynamic> place, {String? icon}) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove old favourite of same type
    state = state.map((p){
      if(p["type"] == type) {
        return {...p, "isFav": false, "type": null, "icon": null};
      }
      return p;
    }).toList();

    // Mark new favourite
    state = state.map((p){
      if(p["title"] == place["title"] && p["subtitle"] == place["subtitle"]) {
        return {...p, "isFav": true, "type": type, "icon": icon};
      }
      return p;
    }).toList();

    await prefs.setStringList('recent_places', state.map((e) => jsonEncode(e)).toList());
    state = [...state]; // notify
  }
}
