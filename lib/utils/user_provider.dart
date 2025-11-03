import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _userProfile = UserProfile.defaultProfile();
  final ImagePicker _imagePicker = ImagePicker();

  UserProfile get userProfile => _userProfile;

  UserProvider() {
    _loadUserProfile();
  }

  // Load user profile from SharedPreferences
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('user_profile');
      
      if (profileJson != null) {
        final Map<String, dynamic> profileMap = jsonDecode(profileJson);
        _userProfile = UserProfile.fromJson(profileMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  // Save user profile to SharedPreferences
  Future<void> _saveUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(_userProfile.toJson());
      await prefs.setString('user_profile', profileJson);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? medicalHistory,
    double? height,
    double? weight,
    String? currentHealthStatus,
  }) async {
    _userProfile = _userProfile.copyWith(
      name: name,
      bio: bio,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      medicalHistory: medicalHistory,
      height: height,
      weight: weight,
      currentHealthStatus: currentHealthStatus,
    );
    await _saveUserProfile();
    notifyListeners();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await _saveProfileImage(image);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
  }

  // Take photo with camera
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await _saveProfileImage(image);
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  // Save profile image to app directory
  Future<void> _saveProfileImage(XFile image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${appDir.path}/$fileName');

      // Copy image to app directory
      await File(image.path).copy(savedImage.path);

      // Delete old profile image if exists
      if (_userProfile.imagePath != null) {
        try {
          final oldFile = File(_userProfile.imagePath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (e) {
          debugPrint('Error deleting old profile image: $e');
        }
      }

      // Update profile with new image path
      _userProfile = _userProfile.copyWith(
        imagePath: savedImage.path,
      );
      await _saveUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving profile image: $e');
    }
  }

  // Remove profile image
  Future<void> removeProfileImage() async {
    try {
      if (_userProfile.imagePath != null) {
        final file = File(_userProfile.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _userProfile = _userProfile.copyWith(
        imagePath: null,
      );
      await _saveUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing profile image: $e');
    }
  }
}
