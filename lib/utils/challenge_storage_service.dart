import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bad_habit_challenge.dart';

/// Service to store and manage bad habit challenges
class ChallengeStorageService {
  static const String _keyChallenges = 'bad_habit_challenges';
  
  /// Save list of challenges to storage
  static Future<void> saveChallenges(List<BadHabitChallenge> challenges) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengesJson = challenges.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(challengesJson);
      await prefs.setString(_keyChallenges, jsonString);
    } catch (e) {
      debugPrint('Error saving challenges: $e');
    }
  }
  
  /// Load list of challenges from storage
  static Future<List<BadHabitChallenge>> loadChallenges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyChallenges);
      
      if (jsonString == null) {
        return [];
      }
      
      final List<dynamic> challengesJson = jsonDecode(jsonString);
      return challengesJson.map((json) => BadHabitChallenge.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading challenges: $e');
      return [];
    }
  }
  
  /// Add a new challenge
  static Future<void> addChallenge(BadHabitChallenge challenge) async {
    final challenges = await loadChallenges();
    challenges.add(challenge);
    await saveChallenges(challenges);
  }
  
  /// Update a challenge by ID
  static Future<void> updateChallenge(BadHabitChallenge updatedChallenge) async {
    final challenges = await loadChallenges();
    final index = challenges.indexWhere((c) => c.id == updatedChallenge.id);
    
    if (index != -1) {
      challenges[index] = updatedChallenge;
      await saveChallenges(challenges);
    }
  }
  
  /// Delete a challenge by ID
  static Future<void> deleteChallenge(String challengeId) async {
    final challenges = await loadChallenges();
    challenges.removeWhere((c) => c.id == challengeId);
    await saveChallenges(challenges);
  }
  
  /// Get a single challenge by ID
  static Future<BadHabitChallenge?> getChallenge(String challengeId) async {
    final challenges = await loadChallenges();
    try {
      return challenges.firstWhere((c) => c.id == challengeId);
    } catch (e) {
      return null;
    }
  }
  
  /// Get active (non-completed) challenges
  static Future<List<BadHabitChallenge>> getActiveChallenges() async {
    final challenges = await loadChallenges();
    return challenges.where((c) => !c.isCompleted).toList();
  }
  
  /// Get completed challenges
  static Future<List<BadHabitChallenge>> getCompletedChallenges() async {
    final challenges = await loadChallenges();
    return challenges.where((c) => c.isCompleted).toList();
  }
  
  /// Get challenges for a specific habit
  static Future<List<BadHabitChallenge>> getChallengesForHabit(String habitId) async {
    final challenges = await loadChallenges();
    return challenges.where((c) => c.habitId == habitId).toList();
  }
  
  /// Clear all challenges (for testing or reset)
  static Future<void> clearAllChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyChallenges);
  }
  
  /// Check if there are any challenges stored
  static Future<bool> hasChallenges() async {
    final challenges = await loadChallenges();
    return challenges.isNotEmpty;
  }
  
  /// Export challenges to JSON string (for backup)
  static Future<String> exportChallengesToJson() async {
    final challenges = await loadChallenges();
    final challengesJson = challenges.map((c) => c.toJson()).toList();
    return jsonEncode(challengesJson);
  }
  
  /// Import challenges from JSON string (for restore)
  static Future<bool> importChallengesFromJson(String jsonString) async {
    try {
      final List<dynamic> challengesJson = jsonDecode(jsonString);
      final challenges = challengesJson.map((json) => BadHabitChallenge.fromJson(json)).toList();
      await saveChallenges(challenges);
      return true;
    } catch (e) {
      debugPrint('Error importing challenges: $e');
      return false;
    }
  }
}
