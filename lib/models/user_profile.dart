class UserProfile {
  final String name;
  final String bio;
  final String? email;
  final String? phone;
  final String? imagePath; // Local file path for profile image
  final DateTime? dateOfBirth; // Ngày tháng năm sinh
  final String? medicalHistory; // Tiền sử bệnh
  final double? height; // Chiều cao (cm)
  final double? weight; // Cân nặng (kg)
  final String? currentHealthStatus; // Tình trạng sức khỏe hiện tại

  UserProfile({
    required this.name,
    required this.bio,
    this.email,
    this.phone,
    this.imagePath,
    this.dateOfBirth,
    this.medicalHistory,
    this.height,
    this.weight,
    this.currentHealthStatus,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'medicalHistory': medicalHistory,
      'height': height,
      'weight': weight,
      'currentHealthStatus': currentHealthStatus,
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'User Name',
      bio: json['bio'] ?? 'Building great habits every day',
      email: json['email'],
      phone: json['phone'],
      imagePath: json['imagePath'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      medicalHistory: json['medicalHistory'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      currentHealthStatus: json['currentHealthStatus'],
    );
  }

  // Create a copy with modified fields
  UserProfile copyWith({
    String? name,
    String? bio,
    String? email,
    String? phone,
    String? imagePath,
    DateTime? dateOfBirth,
    String? medicalHistory,
    double? height,
    double? weight,
    String? currentHealthStatus,
  }) {
    return UserProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      currentHealthStatus: currentHealthStatus ?? this.currentHealthStatus,
    );
  }

  // Default user profile
  factory UserProfile.defaultProfile() {
    return UserProfile(
      name: 'User Name',
      bio: 'Building great habits every day',
    );
  }

  // Check if there are significant changes that might affect habit recommendations
  bool hasSignificantChanges(UserProfile other) {
    // Check name change
    if (name != other.name) {
      return true;
    }
    
    // Check date of birth change (age affects habits)
    if ((dateOfBirth != null && other.dateOfBirth != null) &&
        dateOfBirth != other.dateOfBirth) {
      return true;
    }
    if ((dateOfBirth == null) != (other.dateOfBirth == null)) {
      return true;
    }
    
    // Check height change
    if ((height != null && other.height != null) &&
        (height! - other.height!).abs() > 5) {
      return true; // More than 5cm difference
    }
    if ((height == null) != (other.height == null)) {
      return true;
    }
    
    // Check weight change
    if ((weight != null && other.weight != null) &&
        (weight! - other.weight!).abs() > 3) {
      return true; // More than 3kg difference
    }
    if ((weight == null) != (other.weight == null)) {
      return true;
    }
    
    // Check medical history change
    if ((medicalHistory ?? '') != (other.medicalHistory ?? '')) {
      return true;
    }
    
    // Check current health status change
    if ((currentHealthStatus ?? '') != (other.currentHealthStatus ?? '')) {
      return true;
    }
    
    return false;
  }

  // Get age from date of birth
  int? getAge() {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  // Calculate BMI
  double? getBMI() {
    if (height != null && weight != null && height! > 0) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }
}
