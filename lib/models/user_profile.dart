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
}
