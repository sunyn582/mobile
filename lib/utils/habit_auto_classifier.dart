import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service to automatically classify habits using web search
class HabitAutoClassifier {
  
  /// Classify habit using DuckDuckGo search
  static Future<String> classifyHabitOnline(String habitName) async {
    try {
      // Search for habit + "good" or "bad" keywords
      final query = '$habitName thói quen tốt hay xấu';
      
      // Use DuckDuckGo Instant Answer API (no API key needed)
      final url = Uri.parse(
        'https://api.duckduckgo.com/?q=${Uri.encodeComponent(query)}&format=json&no_html=1'
      );
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final abstract = data['Abstract']?.toString().toLowerCase() ?? '';
        final relatedTopics = data['RelatedTopics'] as List? ?? [];
        
        // Analyze the response text
        String allText = abstract;
        for (var topic in relatedTopics) {
          if (topic is Map && topic['Text'] != null) {
            allText += ' ${topic['Text']}'.toLowerCase();
          }
        }
        
        // Count positive and negative keywords
        final result = _analyzeText(allText);
        if (result != 'uncertain') {
          return result;
        }
      }
      
      // Fallback: Use simple keyword search
      return await _classifyByKeywords(habitName);
      
    } on http.ClientException catch (e) {
      // Network error - no internet connection
      debugPrint('Network error in online classification: $e');
      return await _classifyByKeywords(habitName);
    } catch (e) {
      // Any other error - fallback to keyword classification
      debugPrint('Error in online classification: $e');
      return await _classifyByKeywords(habitName);
    }
  }
  
  /// Analyze text for positive/negative keywords
  static String _analyzeText(String text) {
    // Vietnamese keywords for good habits
    final goodKeywords = [
      'tốt', 'có lợi', 'nên', 'khuyến khích', 'tích cực',
      'lành mạnh', 'hữu ích', 'cần thiết', 'quan trọng',
      'benefits', 'healthy', 'positive', 'good', 'beneficial'
    ];
    
    // Vietnamese keywords for bad habits
    final badKeywords = [
      'xấu', 'có hại', 'không nên', 'tránh', 'tiêu cực',
      'nguy hiểm', 'độc hại', 'gây hại', 'ảnh hưởng xấu',
      'harmful', 'dangerous', 'bad', 'negative', 'avoid'
    ];
    
    int goodScore = 0;
    int badScore = 0;
    
    for (var keyword in goodKeywords) {
      if (text.contains(keyword)) {
        goodScore++;
      }
    }
    
    for (var keyword in badKeywords) {
      if (text.contains(keyword)) {
        badScore++;
      }
    }
    
    // Determine classification based on scores
    if (goodScore > badScore && goodScore >= 2) {
      return 'good';
    } else if (badScore > goodScore && badScore >= 2) {
      return 'bad';
    }
    
    return 'uncertain';
  }
  
  /// Fallback classification using keyword matching
  static Future<String> _classifyByKeywords(String habitName) async {
    final name = habitName.toLowerCase();
    
    // Common bad habit keywords
    final badKeywords = [
      'hút', 'thuốc', 'rượu', 'say', 'nghiện',
      'thức khuya', 'ngủ muộn', 'ăn vặt', 'ăn đêm',
      'lười', 'trì hoãn', 'game', 'điện thoại',
      'smoking', 'drinking', 'lazy', 'procrastinate'
    ];
    
    // Common good habit keywords
    final goodKeywords = [
      'tập', 'thể dục', 'đọc', 'học', 'uống nước',
      'ngủ sớm', 'dậy sớm', 'thiền', 'yoga',
      'exercise', 'read', 'study', 'meditation'
    ];
    
    for (var keyword in badKeywords) {
      if (name.contains(keyword)) {
        return 'bad';
      }
    }
    
    for (var keyword in goodKeywords) {
      if (name.contains(keyword)) {
        return 'good';
      }
    }
    
    return 'uncertain';
  }
  
  /// Get detailed explanation for a habit classification
  static Future<String?> getHabitExplanation(String habitName, String classification) async {
    try {
      final query = '$habitName ${classification == "good" ? "lợi ích" : "tác hại"}';
      final url = Uri.parse(
        'https://api.duckduckgo.com/?q=${Uri.encodeComponent(query)}&format=json&no_html=1'
      );
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final abstract = data['Abstract']?.toString() ?? '';
        
        if (abstract.isNotEmpty) {
          return abstract;
        }
      }
    } catch (e) {
      // Ignore errors
    }
    
    return null;
  }
}
