import '../models/user_profile.dart';

class HealthAssessmentService {
  // BMI Categories based on WHO standards
  static const double underweightThreshold = 18.5;
  static const double normalWeightMax = 24.9;
  static const double overweightMax = 29.9;
  // Above 29.9 is obese

  // Age categories
  static const int youngAdultMax = 30;
  static const int middleAgedMax = 50;
  // Above 50 is senior

  /// Assess user's health status based on profile
  static HealthAssessment assessHealth(UserProfile profile) {
    final bmi = profile.getBMI();
    final age = profile.getAge();
    
    if (bmi == null || age == null) {
      return HealthAssessment(
        status: HealthStatus.unknown,
        message: 'Thiếu thông tin chiều cao, cân nặng hoặc tuổi',
        recommendations: [],
        severity: AlertSeverity.info,
      );
    }

    // Determine BMI category
    final bmiCategory = _getBMICategory(bmi);
    
    // Determine age group
    final ageGroup = _getAgeGroup(age);
    
    // Generate assessment
    return _generateAssessment(bmi, bmiCategory, age, ageGroup, profile);
  }

  static BMICategory _getBMICategory(double bmi) {
    if (bmi < underweightThreshold) return BMICategory.underweight;
    if (bmi <= normalWeightMax) return BMICategory.normal;
    if (bmi <= overweightMax) return BMICategory.overweight;
    return BMICategory.obese;
  }

  static AgeGroup _getAgeGroup(int age) {
    if (age <= youngAdultMax) return AgeGroup.youngAdult;
    if (age <= middleAgedMax) return AgeGroup.middleAged;
    return AgeGroup.senior;
  }

  static HealthAssessment _generateAssessment(
    double bmi,
    BMICategory bmiCategory,
    int age,
    AgeGroup ageGroup,
    UserProfile profile,
  ) {
    String message = '';
    List<String> recommendations = [];
    HealthStatus status = HealthStatus.good;
    AlertSeverity severity = AlertSeverity.info;

    // Assess based on BMI
    switch (bmiCategory) {
      case BMICategory.underweight:
        status = HealthStatus.needsAttention;
        severity = AlertSeverity.warning;
        message = 'Cân nặng của bạn thấp hơn mức khuyến nghị (BMI: ${bmi.toStringAsFixed(1)}).';
        recommendations.addAll([
          'Tăng cường ăn uống đầy đủ dinh dưỡng',
          'Bổ sung protein và calo lành mạnh',
          'Tập gym để tăng cơ bắp',
          'Ngủ đủ 7-8 tiếng mỗi ngày',
          'Khám sức khỏe định kỳ',
        ]);
        break;

      case BMICategory.normal:
        status = HealthStatus.good;
        severity = AlertSeverity.success;
        message = 'Chỉ số BMI của bạn nằm trong mức chuẩn (${bmi.toStringAsFixed(1)}). Tuyệt vời!';
        recommendations.addAll([
          'Duy trì chế độ ăn cân bằng',
          'Tập thể dục 30 phút/ngày',
          'Uống đủ 2 lít nước mỗi ngày',
          'Ngủ đủ giấc',
          'Kiểm tra sức khỏe định kỳ',
        ]);
        break;

      case BMICategory.overweight:
        status = HealthStatus.needsAttention;
        severity = AlertSeverity.warning;
        message = 'Cân nặng của bạn cao hơn mức khuyến nghị (BMI: ${bmi.toStringAsFixed(1)}).';
        recommendations.addAll([
          'Giảm cân từ từ (0.5-1kg/tuần)',
          'Tập cardio 30-45 phút/ngày',
          'Hạn chế đồ ngọt và đồ chiên',
          'Ăn nhiều rau củ và protein nạc',
          'Uống nước thay vì nước ngọt',
        ]);
        break;

      case BMICategory.obese:
        status = HealthStatus.critical;
        severity = AlertSeverity.error;
        message = 'Cân nặng của bạn vượt quá nhiều so với mức khuyến nghị (BMI: ${bmi.toStringAsFixed(1)}). Cần chú ý!';
        recommendations.addAll([
          'Tham khảo ý kiến bác sĩ/chuyên gia dinh dưỡng',
          'Bắt đầu với vận động nhẹ nhàng',
          'Thay đổi chế độ ăn từ từ',
          'Theo dõi calo hàng ngày',
          'Tìm hỗ trợ từ cộng đồng',
        ]);
        break;
    }

    // Add age-specific recommendations
    _addAgeSpecificRecommendations(recommendations, ageGroup, bmiCategory);

    // Check medical history
    if (profile.medicalHistory != null && profile.medicalHistory!.isNotEmpty) {
      recommendations.add('Tuân thủ chỉ định của bác sĩ về bệnh lý hiện có');
    }

    return HealthAssessment(
      status: status,
      message: message,
      recommendations: recommendations,
      severity: severity,
      bmi: bmi,
      age: age,
      bmiCategory: bmiCategory,
      ageGroup: ageGroup,
    );
  }

  static void _addAgeSpecificRecommendations(
    List<String> recommendations,
    AgeGroup ageGroup,
    BMICategory bmiCategory,
  ) {
    switch (ageGroup) {
      case AgeGroup.youngAdult:
        if (bmiCategory != BMICategory.normal) {
          recommendations.add('Xây dựng thói quen lành mạnh từ sớm');
        }
        break;

      case AgeGroup.middleAged:
        recommendations.add('Kiểm tra sức khỏe toàn diện hàng năm');
        if (bmiCategory == BMICategory.overweight || bmiCategory == BMICategory.obese) {
          recommendations.add('Chú ý nguy cơ tiểu đường và tim mạch');
        }
        break;

      case AgeGroup.senior:
        recommendations.add('Tập luyện nhẹ nhàng phù hợp với tuổi');
        recommendations.add('Bổ sung canxi và vitamin D');
        if (bmiCategory == BMICategory.underweight) {
          recommendations.add('Duy trì cân nặng để tránh loãng xương');
        }
        break;
    }
  }

  /// Get suggested habits based on health assessment
  static List<Map<String, dynamic>> getSuggestedHabits(HealthAssessment assessment) {
    List<Map<String, dynamic>> habits = [];

    // Common healthy habits
    habits.addAll([
      {
        'name': 'Uống 2 lít nước mỗi ngày',
        'icon': '💧',
        'category': 'Health',
        'color': '#56CCF2',
        'minutes': 5,
        'description': 'Duy trì độ ẩm cho cơ thể, giúp trao đổi chất tốt hơn',
      },
      {
        'name': 'Ngủ đủ 7-8 tiếng',
        'icon': '😴',
        'category': 'Health',
        'color': '#BB6BD9',
        'minutes': 480,
        'description': 'Phục hồi năng lượng và tăng cường hệ miễn dịch',
      },
    ]);

    // BMI-specific habits
    if (assessment.bmiCategory != null) {
      switch (assessment.bmiCategory!) {
        case BMICategory.underweight:
          habits.addAll([
            {
              'name': 'Ăn 5-6 bữa nhỏ mỗi ngày',
              'icon': '🍱',
              'category': 'Health',
              'color': '#6FCF97',
              'minutes': 30,
              'description': 'Tăng lượng calo nạp vào một cách lành mạnh',
            },
            {
              'name': 'Tập gym tăng cơ',
              'icon': '🏋️',
              'category': 'Health',
              'color': '#F2994A',
              'minutes': 45,
              'description': 'Xây dựng khối cơ, tăng cân khỏe mạnh',
            },
          ]);
          break;

        case BMICategory.normal:
          habits.addAll([
            {
              'name': 'Tập thể dục 30 phút',
              'icon': '🏃',
              'category': 'Health',
              'color': '#6FCF97',
              'minutes': 30,
              'description': 'Duy trì thể trạng tốt và sức khỏe tim mạch',
            },
            {
              'name': 'Ăn rau củ mỗi bữa',
              'icon': '🥗',
              'category': 'Health',
              'color': '#6FCF97',
              'minutes': 15,
              'description': 'Cung cấp vitamin và chất xơ cần thiết',
            },
          ]);
          break;

        case BMICategory.overweight:
        case BMICategory.obese:
          habits.addAll([
            {
              'name': 'Chạy bộ/Đi bộ nhanh 45 phút',
              'icon': '🏃',
              'category': 'Health',
              'color': '#EB5757',
              'minutes': 45,
              'description': 'Đốt cháy calo, giảm mỡ thừa hiệu quả',
            },
            {
              'name': 'Hạn chế đồ ngọt & chiên rán',
              'icon': '🚫',
              'category': 'Health',
              'color': '#EB5757',
              'minutes': 0,
              'description': 'Giảm lượng calo và chất béo không lành mạnh',
            },
            {
              'name': 'Theo dõi calo hàng ngày',
              'icon': '📊',
              'category': 'Health',
              'color': '#2F80ED',
              'minutes': 10,
              'description': 'Kiểm soát lượng calo nạp vào để giảm cân',
            },
          ]);
          break;
      }
    }

    // Age-specific habits
    if (assessment.ageGroup != null) {
      switch (assessment.ageGroup!) {
        case AgeGroup.youngAdult:
          habits.add({
            'name': 'Học kỹ năng mới',
            'icon': '📚',
            'category': 'Study',
            'color': '#2F80ED',
            'minutes': 30,
            'description': 'Phát triển bản thân và sự nghiệp',
          });
          break;

        case AgeGroup.middleAged:
          habits.add({
            'name': 'Thiền/Yoga giảm stress',
            'icon': '🧘',
            'category': 'Mind',
            'color': '#9B51E0',
            'minutes': 20,
            'description': 'Giảm căng thẳng, cân bằng công việc - cuộc sống',
          });
          break;

        case AgeGroup.senior:
          habits.add({
            'name': 'Dạo bộ nhẹ nhàng',
            'icon': '🚶',
            'category': 'Health',
            'color': '#6FCF97',
            'minutes': 30,
            'description': 'Vận động nhẹ nhàng phù hợp với tuổi',
          });
          break;
      }
    }

    return habits;
  }
}

// Enums
enum BMICategory {
  underweight,
  normal,
  overweight,
  obese,
}

enum AgeGroup {
  youngAdult, // <= 30
  middleAged, // 31-50
  senior, // > 50
}

enum HealthStatus {
  unknown,
  good,
  needsAttention,
  critical,
}

enum AlertSeverity {
  info,
  success,
  warning,
  error,
}

// Health Assessment Result
class HealthAssessment {
  final HealthStatus status;
  final String message;
  final List<String> recommendations;
  final AlertSeverity severity;
  final double? bmi;
  final int? age;
  final BMICategory? bmiCategory;
  final AgeGroup? ageGroup;

  HealthAssessment({
    required this.status,
    required this.message,
    required this.recommendations,
    required this.severity,
    this.bmi,
    this.age,
    this.bmiCategory,
    this.ageGroup,
  });

  String getSeverityColor() {
    switch (severity) {
      case AlertSeverity.success:
        return '#4CAF50'; // Green
      case AlertSeverity.warning:
        return '#FF9800'; // Orange
      case AlertSeverity.error:
        return '#F44336'; // Red
      case AlertSeverity.info:
        return '#2196F3'; // Blue
    }
  }

  String getSeverityIcon() {
    switch (severity) {
      case AlertSeverity.success:
        return '✅';
      case AlertSeverity.warning:
        return '⚠️';
      case AlertSeverity.error:
        return '🚨';
      case AlertSeverity.info:
        return 'ℹ️';
    }
  }

  String getBMICategoryText() {
    switch (bmiCategory) {
      case BMICategory.underweight:
        return 'Thiếu cân';
      case BMICategory.normal:
        return 'Bình thường';
      case BMICategory.overweight:
        return 'Thừa cân';
      case BMICategory.obese:
        return 'Béo phì';
      default:
        return 'Không rõ';
    }
  }

  String getAgeGroupText() {
    switch (ageGroup) {
      case AgeGroup.youngAdult:
        return 'Trẻ tuổi';
      case AgeGroup.middleAged:
        return 'Trung niên';
      case AgeGroup.senior:
        return 'Người cao tuổi';
      default:
        return 'Không rõ';
    }
  }

  bool needsAttention() {
    return status == HealthStatus.needsAttention || status == HealthStatus.critical;
  }
}
