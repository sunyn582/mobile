/// Form validators for user input validation
class FormValidators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    
    return null;
  }
  
  /// Validate phone number (Vietnamese format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    // Remove spaces and special characters
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Vietnamese phone format: 10 digits starting with 0
    // or international format: +84 followed by 9 digits
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
    
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)';
    }
    
    return null;
  }
  
  /// Validate height in cm
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Height is optional
    }
    
    final height = double.tryParse(value);
    
    if (height == null) {
      return 'Chiều cao phải là số';
    }
    
    if (height < 50 || height > 250) {
      return 'Chiều cao phải từ 50-250 cm';
    }
    
    return null;
  }
  
  /// Validate weight in kg
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Weight is optional
    }
    
    final weight = double.tryParse(value);
    
    if (weight == null) {
      return 'Cân nặng phải là số';
    }
    
    if (weight < 20 || weight > 300) {
      return 'Cân nặng phải từ 20-300 kg';
    }
    
    return null;
  }
  
  /// Validate name (required)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên không được để trống';
    }
    
    if (value.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    
    if (value.trim().length > 50) {
      return 'Tên không được quá 50 ký tự';
    }
    
    return null;
  }
  
  /// Validate habit name
  static String? validateHabitName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên thói quen không được để trống';
    }
    
    if (value.trim().length < 2) {
      return 'Tên thói quen phải có ít nhất 2 ký tự';
    }
    
    if (value.trim().length > 100) {
      return 'Tên thói quen không được quá 100 ký tự';
    }
    
    return null;
  }
  
  /// Validate target minutes
  static String? validateTargetMinutes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Thời gian mục tiêu không được để trống';
    }
    
    final minutes = int.tryParse(value);
    
    if (minutes == null) {
      return 'Thời gian phải là số nguyên';
    }
    
    if (minutes < 1 || minutes > 1440) {
      return 'Thời gian phải từ 1-1440 phút (24 giờ)';
    }
    
    return null;
  }
  
  /// Validate age (derived from date of birth)
  static String? validateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return null; // Date of birth is optional
    }
    
    final today = DateTime.now();
    final age = today.year - dateOfBirth.year;
    
    if (dateOfBirth.isAfter(today)) {
      return 'Ngày sinh không thể ở tương lai';
    }
    
    if (age < 5 || age > 120) {
      return 'Tuổi phải từ 5-120';
    }
    
    return null;
  }
  
  /// Validate bio/description
  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Bio is optional
    }
    
    if (value.length > 500) {
      return 'Mô tả không được quá 500 ký tự';
    }
    
    return null;
  }
  
  /// Validate medical history
  static String? validateMedicalHistory(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Medical history is optional
    }
    
    if (value.length > 1000) {
      return 'Tiền sử bệnh không được quá 1000 ký tự';
    }
    
    return null;
  }
  
  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'URL không hợp lệ';
    }
    
    return null;
  }
  
  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName không được để trống';
    }
    
    return null;
  }
  
  /// Validate number in range
  static String? validateNumberRange(
    String? value,
    double min,
    double max,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final number = double.tryParse(value);
    
    if (number == null) {
      return '$fieldName phải là số';
    }
    
    if (number < min || number > max) {
      return '$fieldName phải từ $min-$max';
    }
    
    return null;
  }
}
