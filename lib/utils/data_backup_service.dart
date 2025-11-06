import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart'; // Uncomment when share_plus is added to pubspec.yaml
import 'habit_storage_service.dart';
import 'challenge_storage_service.dart';
import 'user_storage_service.dart';

/// Service to export and import all app data (habits, challenges, user profile)
class DataBackupService {
  /// Export all data to JSON string
  static Future<String> exportAllData() async {
    try {
      // Get all data
      final habits = await HabitStorageService.loadHabits();
      final challenges = await ChallengeStorageService.loadChallenges();
      final userProfile = await UserStorageService.getCurrentUser();
      
      // Combine into single JSON object
      final allData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'habits': habits.map((h) => h.toJson()).toList(),
        'challenges': challenges.map((c) => c.toJson()).toList(),
        'userProfile': userProfile?.toJson(),
      };
      
      return jsonEncode(allData);
    } catch (e) {
      debugPrint('Error exporting data: $e');
      throw Exception('Failed to export data');
    }
  }
  
  /// Import all data from JSON string
  static Future<bool> importAllData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Validate version
      final version = data['version'] as String?;
      if (version != '1.0') {
        debugPrint('Unsupported backup version: $version');
        return false;
      }
      
      // Import habits
      if (data['habits'] != null) {
        final habitsJson = jsonEncode(data['habits']);
        await HabitStorageService.importHabitsFromJson(habitsJson);
      }
      
      // Import challenges
      if (data['challenges'] != null) {
        final challengesJson = jsonEncode(data['challenges']);
        await ChallengeStorageService.importChallengesFromJson(challengesJson);
      }
      
      // Import user profile
      if (data['userProfile'] != null) {
        // User profile import is handled separately to avoid overwriting current user
        // You can implement this based on your needs
      }
      
      return true;
    } catch (e) {
      debugPrint('Error importing data: $e');
      return false;
    }
  }
  
  /// Save backup to file in app documents directory
  static Future<File> saveBackupToFile() async {
    try {
      final jsonString = await exportAllData();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/habit_backup_$timestamp.json');
      
      await file.writeAsString(jsonString);
      return file;
    } catch (e) {
      debugPrint('Error saving backup to file: $e');
      throw Exception('Failed to save backup');
    }
  }
  
  /// Load backup from file
  static Future<bool> loadBackupFromFile(File file) async {
    try {
      final jsonString = await file.readAsString();
      return await importAllData(jsonString);
    } catch (e) {
      debugPrint('Error loading backup from file: $e');
      return false;
    }
  }
  
  /// Share backup file (user can save to cloud, email, etc.)
  /// Note: Requires share_plus package to be added to pubspec.yaml
  static Future<String> shareBackup() async {
    try {
      final file = await saveBackupToFile();
      
      // Note: share_plus package needs to be added to pubspec.yaml
      // To enable sharing, add to pubspec.yaml:
      //   dependencies:
      //     share_plus: ^7.2.1
      // Then uncomment this code:
      // await Share.shareXFiles([XFile(file.path)], text: 'Habit Tracker Backup');
      
      debugPrint('Backup saved to: ${file.path}');
      return file.path;
    } catch (e) {
      debugPrint('Error sharing backup: $e');
      throw Exception('Failed to share backup');
    }
  }
  
  /// Get list of all backup files
  static Future<List<File>> getBackupFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .whereType<File>()
          .where((file) => file.path.contains('habit_backup_'))
          .toList();
      
      // Sort by modification time (newest first)
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
      
      return files;
    } catch (e) {
      debugPrint('Error getting backup files: $e');
      return [];
    }
  }
  
  /// Delete a backup file
  static Future<bool> deleteBackup(File file) async {
    try {
      await file.delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting backup: $e');
      return false;
    }
  }
  
  /// Get backup info (size, date, etc.)
  static Future<Map<String, dynamic>> getBackupInfo(File file) async {
    try {
      final stat = await file.stat();
      final size = stat.size;
      final modified = stat.modified;
      
      // Try to read backup to get habit/challenge counts
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      return {
        'path': file.path,
        'size': size,
        'sizeKB': (size / 1024).toStringAsFixed(2),
        'modified': modified,
        'exportDate': data['exportDate'],
        'habitCount': (data['habits'] as List?)?.length ?? 0,
        'challengeCount': (data['challenges'] as List?)?.length ?? 0,
      };
    } catch (e) {
      debugPrint('Error getting backup info: $e');
      return {};
    }
  }
}
