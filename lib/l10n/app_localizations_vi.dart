// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Theo Dõi Thói Quen';

  @override
  String get welcomeSlogan => 'Xây dựng thói quen tốt,\ntừng ngày một.';

  @override
  String get getStarted => 'Bắt Đầu';

  @override
  String get myHabits => 'Thói Quen Của Tôi';

  @override
  String get goodMorning => 'Chào buổi sáng! ☀️';

  @override
  String get goodAfternoon => 'Chào buổi chiều! 🌤️';

  @override
  String get goodEvening => 'Chào buổi tối! 🌙';

  @override
  String get keepBuildingHabits => 'Tiếp tục xây dựng thói quen tốt!';

  @override
  String get todayProgress => 'Tiến Độ Hôm Nay';

  @override
  String get yourHabits => 'Thói Quen Của Bạn';

  @override
  String get addNew => 'Thêm Mới';

  @override
  String get noHabitsYet => 'Chưa có thói quen nào';

  @override
  String get tapAddNewHabit => 'Nhấn \"Thêm Mới\" để tạo thói quen đầu tiên';

  @override
  String get addNewHabit => 'Thêm Thói Quen Mới';

  @override
  String get editHabit => 'Chỉnh Sửa Thói Quen';

  @override
  String get save => 'Lưu';

  @override
  String get habitName => 'Tên Thói Quen';

  @override
  String get habitNameHint => 'VD: Thiền buổi sáng';

  @override
  String get pleaseEnterHabitName => 'Vui lòng nhập tên thói quen';

  @override
  String get chooseIcon => 'Chọn Biểu Tượng';

  @override
  String get category => 'Danh Mục';

  @override
  String get categoryHealth => 'Sức khỏe';

  @override
  String get categoryStudy => 'Học tập';

  @override
  String get categoryMind => 'Tâm trí';

  @override
  String get categoryWork => 'Công việc';

  @override
  String get categorySocial => 'Xã hội';

  @override
  String get categoryCustom => 'Tùy chỉnh';

  @override
  String get chooseColor => 'Chọn Màu Sắc';

  @override
  String get dailyTarget => 'Mục Tiêu Hàng Ngày';

  @override
  String get minutes => 'phút';

  @override
  String get reminderOptional => 'Nhắc Nhở (Tùy chọn)';

  @override
  String remindMeAt(String time) {
    return 'Nhắc tôi lúc $time';
  }

  @override
  String get setReminderTime => 'Đặt thời gian nhắc nhở';

  @override
  String get createHabit => 'Tạo Thói Quen';

  @override
  String get updateHabit => 'Cập Nhật Thói Quen';

  @override
  String get habitDetails => 'Chi Tiết Thói Quen';

  @override
  String get dayStreak => 'Chuỗi Ngày';

  @override
  String get completion => 'Hoàn Thành';

  @override
  String get weeklyProgress => 'Tiến Độ Tuần';

  @override
  String get habitInfo => 'Thông Tin Thói Quen';

  @override
  String minutesPerDay(int minutes) {
    return '$minutes phút/ngày';
  }

  @override
  String categoryLabel(String category) {
    return 'Danh mục: $category';
  }

  @override
  String reminderLabel(String time) {
    return 'Nhắc nhở: $time';
  }

  @override
  String get deleteHabit => 'Xóa Thói Quen';

  @override
  String get deleteHabitConfirm => 'Bạn có chắc chắn muốn xóa thói quen này?';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get mon => 'T2';

  @override
  String get tue => 'T3';

  @override
  String get wed => 'T4';

  @override
  String get thu => 'T5';

  @override
  String get fri => 'T6';

  @override
  String get sat => 'T7';

  @override
  String get sun => 'CN';

  @override
  String get profileAndSettings => 'Hồ Sơ & Cài Đặt';

  @override
  String get userName => 'Tên Người Dùng';

  @override
  String get buildingHabitsEveryDay => 'Xây dựng thói quen tốt mỗi ngày';

  @override
  String get settings => 'Cài Đặt';

  @override
  String get darkMode => 'Chế Độ Tối';

  @override
  String get switchTheme => 'Chuyển đổi giữa giao diện sáng và tối';

  @override
  String get language => 'Tiếng Việt';

  @override
  String get switchLanguage => 'Chuyển đổi ngôn ngữ';

  @override
  String get aboutThisProject => 'Về Dự Án Này';

  @override
  String get project => 'Dự án';

  @override
  String get projectName => 'Ứng Dụng Theo Dõi Thói Quen';

  @override
  String get course => 'Môn học';

  @override
  String get courseName => 'Lập Trình Cho Thiết Bị Di Động';

  @override
  String get studentName => 'Tên sinh viên';

  @override
  String get studentNamePlaceholder => 'Vũ Văn Sơn';

  @override
  String get studentId => 'Mã sinh viên';

  @override
  String get studentIdPlaceholder => '23010060';

  @override
  String get instructor => 'Giảng viên';

  @override
  String get instructorPlaceholder => 'Nguyễn Xuân Quế';

  @override
  String get version => 'Phiên bản';

  @override
  String get aboutApp =>
      'Dự án này được phát triển cho môn Lập trình thiết bị di động. Ứng dụng giúp người dùng theo dõi và xây dựng thói quen tích cực thông qua sự kiên trì hàng ngày.';

  @override
  String get helpAndSupport => 'Trợ Giúp & Hỗ Trợ';

  @override
  String get helpMessage =>
      'Để được trợ giúp hoặc hỗ trợ, vui lòng liên hệ với giảng viên hoặc xem tài liệu hướng dẫn của dự án.';

  @override
  String get ok => 'Đồng Ý';

  @override
  String minsPerDay(int mins) {
    return '$mins phút/ngày';
  }

  @override
  String get day => 'ngày';

  @override
  String get days => 'ngày';

  @override
  String get editProfile => 'Chỉnh Sửa Hồ Sơ';

  @override
  String get changePhoto => 'Thay Đổi Ảnh';

  @override
  String get takePhoto => 'Chụp Ảnh';

  @override
  String get chooseFromGallery => 'Chọn Từ Thư Viện';

  @override
  String get removePhoto => 'Xóa Ảnh';

  @override
  String get name => 'Tên';

  @override
  String get bio => 'Tiểu Sử';

  @override
  String get pleaseEnterName => 'Vui lòng nhập tên của bạn';

  @override
  String get pleaseEnterBio => 'Vui lòng nhập tiểu sử của bạn';

  @override
  String get saveChanges => 'Lưu Thay Đổi';

  @override
  String get personalInformation => 'Thông Tin Cá Nhân';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get phone => 'Số Điện Thoại';

  @override
  String get phoneHint => '+84 123 456 789';

  @override
  String get pleaseEnterValidEmail => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get groupInformation => 'Thông Tin Nhóm';

  @override
  String get viewProjectDetails => 'Xem thông tin dự án và nhóm';

  @override
  String get dateOfBirth => 'Ngày Sinh';

  @override
  String get selectDate => 'Chọn Ngày';

  @override
  String get medicalHistory => 'Tiền Sử Bệnh';

  @override
  String get medicalHistoryHint =>
      'VD: Dị ứng, bệnh mãn tính, phẫu thuật trước đây...';

  @override
  String get height => 'Chiều Cao (cm)';

  @override
  String get heightHint => 'VD: 170';

  @override
  String get weight => 'Cân Nặng (kg)';

  @override
  String get weightHint => 'VD: 65';

  @override
  String get currentHealthStatus => 'Tình Trạng Sức Khỏe Hiện Tại';

  @override
  String get healthStatusHint => 'VD: Tốt, Đang hồi phục, Đang điều trị...';

  @override
  String get healthInformation => 'Thông Tin Sức Khỏe';

  @override
  String get bmi => 'Chỉ số BMI';

  @override
  String get welcomeBack => 'Chào Mừng Trở Lại!';

  @override
  String continueAsUser(String name) {
    return 'Tiếp tục với tài khoản $name';
  }

  @override
  String get createNewProfile => 'Tạo Hồ Sơ Mới';

  @override
  String get enterYourName => 'Nhập tên của bạn';

  @override
  String get yourNameHint => 'VD: Nguyễn Văn A';

  @override
  String get letsStart => 'Bắt Đầu Thôi!';
}
