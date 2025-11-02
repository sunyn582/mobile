class UserProfile {
  final String name;
  final String bio;
  final String? email;
  final String? phone;
  final String? imagePath; // Local file path for profile image

  UserProfile({
    required this.name,
    required this.bio,
    this.email,
    this.phone,
    this.imagePath,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
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
    );
  }

  // Create a copy with modified fields
  UserProfile copyWith({
    String? name,
    String? bio,
    String? email,
    String? phone,
    String? imagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
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
