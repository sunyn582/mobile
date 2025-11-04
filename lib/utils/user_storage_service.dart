import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

/// Service để lưu trữ và quản lý thông tin người dùng
class UserStorageService {
  static const String _keyIsFirstTime = 'is_first_time';
  static const String _keyCurrentUser = 'current_user_profile'; // Người đang dùng
  static const String _keyPreviousUser = 'previous_user_profile'; // Người cũ (từng dùng trước đó)
  
  /// Kiểm tra xem đây có phải lần đầu người dùng mở app không
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFirstTime) ?? true;
  }
  
  /// Đánh dấu người dùng đã từng sử dụng app
  static Future<void> markAsReturningUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstTime, false);
  }
  
  /// Lưu thông tin người dùng ĐANG DÙNG
  static Future<void> saveCurrentUser(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lưu người đang dùng hiện tại thành người cũ (backup)
    final currentUserJson = prefs.getString(_keyCurrentUser);
    if (currentUserJson != null) {
      await prefs.setString(_keyPreviousUser, currentUserJson);
    }
    
    // Lưu người dùng mới vào current
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_keyCurrentUser, jsonString);
  }
  
  /// Lấy thông tin người dùng ĐANG DÙNG
  static Future<UserProfile?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyCurrentUser);
    
    if (jsonString == null) {
      return null;
    }
    
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
  
  /// Lấy thông tin người dùng CŨ (từng dùng trước đó)
  static Future<UserProfile?> getPreviousUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyPreviousUser);
    
    if (jsonString == null) {
      return null;
    }
    
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }
  
  /// Chuyển đổi sang tài khoản cũ (swap previous -> current)
  static Future<void> switchToPreviousUser() async {
    final previousUser = await getPreviousUser();
    if (previousUser != null) {
      await saveCurrentUser(previousUser);
    }
  }
  
  /// Lưu thông tin người dùng (backward compatibility)
  @Deprecated('Use saveCurrentUser instead')
  static Future<void> saveUserProfile(UserProfile profile) async {
    await saveCurrentUser(profile);
  }
  
  /// Lấy thông tin người dùng đã lưu (backward compatibility)
  @Deprecated('Use getCurrentUser instead')
  static Future<UserProfile?> getUserProfile() async {
    return await getCurrentUser();
  }
  
  /// Xóa toàn bộ dữ liệu người dùng (để test hoặc reset app)
  static Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsFirstTime);
    await prefs.remove(_keyCurrentUser);
    await prefs.remove(_keyPreviousUser);
  }
  
  /// Kiểm tra xem có thông tin người dùng đã lưu không
  static Future<bool> hasUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyCurrentUser);
  }
  
  /// Kiểm tra xem có người dùng cũ không
  static Future<bool> hasPreviousUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPreviousUser);
  }
}
