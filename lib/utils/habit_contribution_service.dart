import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service to store user-contributed habit classifications
class HabitContributionService {
  static const String _keyGoodHabits = 'user_contributed_good_habits';
  static const String _keyBadHabits = 'user_contributed_bad_habits';
  static const String _keyUserOpinions = 'user_opinions'; // Stores user opinions (not verified yet)

  /// Save user's opinion (not verified classification yet)
  static Future<void> saveUserOpinion(String habitName, String opinion) async {
    final prefs = await SharedPreferences.getInstance();
    final opinions = await _getUserOpinions();
    
    // Store as map: habitName -> {opinion, timestamp, verified}
    opinions[habitName.toLowerCase().trim()] = {
      'opinion': opinion,
      'timestamp': DateTime.now().toIso8601String(),
      'verified': false,
    };
    
    await prefs.setString(_keyUserOpinions, jsonEncode(opinions));
  }

  /// Get all user opinions
  static Future<Map<String, dynamic>> _getUserOpinions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUserOpinions);
    if (jsonString == null) return {};
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded;
    } catch (e) {
      return {};
    }
  }

  /// Save a user-classified habit
  static Future<void> saveHabitClassification(String habitName, String type) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (type == 'good') {
      await _addToList(prefs, _keyGoodHabits, habitName);
    } else if (type == 'bad') {
      await _addToList(prefs, _keyBadHabits, habitName);
    }
  }

  /// Get all user-contributed good habits
  static Future<List<String>> getGoodHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyGoodHabits);
  }

  /// Get all user-contributed bad habits
  static Future<List<String>> getBadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyBadHabits);
  }

  /// Check if a habit has been classified by user
  static Future<String?> getHabitClassification(String habitName) async {
    final goodHabits = await getGoodHabits();
    final badHabits = await getBadHabits();
    
    final normalizedName = habitName.toLowerCase().trim();
    
    if (goodHabits.any((h) => h.toLowerCase().trim() == normalizedName)) {
      return 'good';
    }
    if (badHabits.any((h) => h.toLowerCase().trim() == normalizedName)) {
      return 'bad';
    }
    
    return null;
  }

  /// Clear all user contributions
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGoodHabits);
    await prefs.remove(_keyBadHabits);
    await prefs.remove(_keyUserOpinions);
  }

  // Helper methods
  static Future<void> _addToList(SharedPreferences prefs, String key, String value) async {
    final list = _getList(prefs, key);
    
    // Avoid duplicates (case-insensitive)
    final normalizedValue = value.toLowerCase().trim();
    if (!list.any((item) => item.toLowerCase().trim() == normalizedValue)) {
      list.add(value);
      await prefs.setString(key, jsonEncode(list));
    }
  }

  static List<String> _getList(SharedPreferences prefs, String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }
}
