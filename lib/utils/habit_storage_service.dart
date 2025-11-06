import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

/// Service to store and manage user habits
class HabitStorageService {
  static const String _keyHabits = 'user_habits';
  
  /// Save list of habits to storage
  static Future<void> saveHabits(List<Habit> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = habits.map((habit) => habit.toJson()).toList();
      final jsonString = jsonEncode(habitsJson);
      await prefs.setString(_keyHabits, jsonString);
    } catch (e) {
      // Log error but don't throw to prevent app crash
      debugPrint('Error saving habits: $e');
    }
  }
  
  /// Load list of habits from storage
  static Future<List<Habit>> loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyHabits);
      
      if (jsonString == null) {
        return [];
      }
      
      final List<dynamic> habitsJson = jsonDecode(jsonString);
      return habitsJson.map((json) => Habit.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading habits: $e');
      return [];
    }
  }
  
  /// Add a single habit
  static Future<void> addHabit(Habit habit) async {
    final habits = await loadHabits();
    habits.add(habit);
    await saveHabits(habits);
  }
  
  /// Update a habit by ID
  static Future<void> updateHabit(Habit updatedHabit) async {
    final habits = await loadHabits();
    final index = habits.indexWhere((h) => h.id == updatedHabit.id);
    
    if (index != -1) {
      habits[index] = updatedHabit;
      await saveHabits(habits);
    }
  }
  
  /// Delete a habit by ID
  static Future<void> deleteHabit(String habitId) async {
    final habits = await loadHabits();
    habits.removeWhere((h) => h.id == habitId);
    await saveHabits(habits);
  }
  
  /// Get a single habit by ID
  static Future<Habit?> getHabit(String habitId) async {
    final habits = await loadHabits();
    try {
      return habits.firstWhere((h) => h.id == habitId);
    } catch (e) {
      return null;
    }
  }
  
  /// Clear all habits (for testing or reset)
  static Future<void> clearAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHabits);
  }
  
  /// Check if there are any habits stored
  static Future<bool> hasHabits() async {
    final habits = await loadHabits();
    return habits.isNotEmpty;
  }
  
  /// Export habits to JSON string (for backup)
  static Future<String> exportHabitsToJson() async {
    final habits = await loadHabits();
    final habitsJson = habits.map((habit) => habit.toJson()).toList();
    return jsonEncode(habitsJson);
  }
  
  /// Import habits from JSON string (for restore)
  static Future<bool> importHabitsFromJson(String jsonString) async {
    try {
      final List<dynamic> habitsJson = jsonDecode(jsonString);
      final habits = habitsJson.map((json) => Habit.fromJson(json)).toList();
      await saveHabits(habits);
      return true;
    } catch (e) {
      debugPrint('Error importing habits: $e');
      return false;
    }
  }
}
