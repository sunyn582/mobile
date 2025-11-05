# 🌱 Habit Tracker - Ứng dụng Quản lý Thói quen Thông minh

> Xây dựng thói quen tốt, loại bỏ thói quen xấu, cải thiện sức khỏe - Tất cả trong một ứng dụng!

## 👥 Thông tin Nhóm

| Thông tin | Chi tiết |
|-----------|----------|
| **Tên đề tài** | Ứng dụng Quản lý Thói quen Thông minh |
| **Môn học** | Lập trình cho thiết bị di động |
| **Lớp** | Lập trình cho thiết bị di động-1-1-25(N05) |
| **Giảng viên** | Nguyễn Xuân Quế |
| **Học kỳ** | 2025-2026 |

### 👨‍💻 Thông tin nhóm

| Thông tin | Chi tiết |
|-----------|----------|
| **Họ và tên sinh viên** | Vũ Văn Sơn |
| **MSSV** | 23010060 |
| **Lớp** | Lập trình cho thiết bị di động-1-1-25(N05) |
| **Email** | 23010060@st.phenikaa-uni.edu.vn |
| **Email cá nhân** | sbaddboy@gmail.com |
| **Học kỳ** | 2025-2026 |

---

## 📋 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng chính](#-tính-năng-chính)
- [Công nghệ sử dụng](#️-công-nghệ-sử-dụng)
- [Cài đặt](#-cài-đặt)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Hướng dẫn sử dụng](#-hướng-dẫn-sử-dụng)
- [Screenshots](#-screenshots)
- [Kiến trúc](#️-kiến-trúc)
- [Testing](#-testing)
- [Đóng góp](#-đóng-góp)
- [License](#-license)

---

## 📱 Giới thiệu

**Habit Tracker** là ứng dụng di động toàn diện giúp người dùng xây dựng thói quen tốt, loại bỏ thói quen xấu, và cải thiện sức khỏe một cách khoa học và hiệu quả.

### 🎯 Mục tiêu dự án

- Giúp người dùng theo dõi và duy trì thói quen tốt hàng ngày
- Hỗ trợ bỏ thói quen xấu với các chiến lược khác nhau
- Đánh giá sức khỏe và đưa ra gợi ý thói quen phù hợp
- Tạo động lực thông qua gamification và milestone celebrations
- Cung cấp insights chi tiết về tiến độ và thống kê

### ✨ Điểm nổi bật

- 🎨 **UI/UX đẹp mắt**: Thiết kế hiện đại, trực quan với Material Design 3
- 🌓 **Dark Mode**: Hỗ trợ chế độ sáng/tối
- 🌍 **Đa ngôn ngữ**: Tiếng Việt và Tiếng Anh
- 📊 **Thống kê chi tiết**: Biểu đồ, progress bars, streaks
- 🔔 **Thông báo thông minh**: Nhắc nhở theo từng mức độ cam kết
- 💪 **Khoa học**: Dựa trên WHO BMI standards và nghiên cứu tâm lý học

---

## 🚀 Tính năng chính

### 1. 📝 Quản lý Thói quen Tốt

- ✅ Thêm/Sửa/Xóa thói quen
- ✅ Phân loại theo danh mục (Health, Study, Mind, Work, Social)
- ✅ Chọn icon và màu sắc cá nhân hóa
- ✅ Đặt mục tiêu thời gian hàng ngày
- ✅ Theo dõi streak (chuỗi ngày liên tiếp)
- ✅ Progress tracking với biểu đồ
- ✅ Thống kê tỷ lệ hoàn thành

**Màn hình:**
- Home Screen: Dashboard với tất cả thói quen
- Add Habit Screen: Form thêm thói quen mới
- Habit Detail Screen: Chi tiết tiến độ và thống kê
- Suggested Habits Screen: Gợi ý thói quen sẵn có

### 2. 🚫 Quản lý Bỏ Thói quen Xấu

#### **3 Mức độ Cam kết:**

| Mức độ | Thời gian | Thông báo | Phù hợp với |
|--------|-----------|-----------|-------------|
| 🐢 **Từ từ** | 3-6 tháng | 1 lần/ngày (6h) | Người mới bắt đầu |
| 🚶 **Vừa phải** | 1.5-3 tháng | 2 lần/ngày (6h, 18h) | Quyết tâm trung bình |
| 🏃 **Kiên quyết** | 15-30 ngày | Mỗi 3 tiếng (6h-0h) | Ý chí mạnh mẽ |

#### **Tính năng:**
- ⏰ Điểm danh cố định vào 22h mỗi ngày
- 🎯 Tự động đánh dấu thất bại nếu bỏ lỡ
- 📅 Tùy chọn thời gian cam kết trong khoảng min-max
- 🏆 Kết thúc với ngưỡng 90% (thành công/chưa hoàn thành)
- 🎉 Celebration milestones: 1/3, 1/2, 100%
- 📊 Lịch sử 7 ngày và thống kê chi tiết

**Màn hình:**
- Bad Habits Screen: Danh sách thói quen xấu
- Bad Habit Progress Screen: Theo dõi tiến độ bỏ thói quen

### 3. 🏥 Đánh giá Sức khỏe & Gợi ý

#### **Health Assessment:**
- 📊 Tính BMI tự động từ chiều cao và cân nặng
- 👥 Phân nhóm tuổi (Trẻ tuổi / Trung niên / Cao tuổi)
- 🎯 Đánh giá theo tiêu chuẩn WHO

#### **BMI Categories:**

| Loại | BMI | Cảnh báo | Màu |
|------|-----|----------|-----|
| Thiếu cân | < 18.5 | ⚠️ Warning | Cam |
| Bình thường | 18.5 - 24.9 | ✅ Good | Xanh |
| Thừa cân | 25.0 - 29.9 | ⚠️ Warning | Cam |
| Béo phì | ≥ 30.0 | 🚨 Critical | Đỏ |

#### **Smart Recommendations:**
- Gợi ý thói quen dựa trên BMI và tuổi
- 5-8 thói quen được cá nhân hóa
- Khuyến nghị dinh dưỡng và vận động
- Thêm nhanh vào lịch trình

**Màn hình:**
- Health Recommendations Screen: Đánh giá và gợi ý chi tiết
- Health Alert Banner trong Profile Screen

### 4. 👤 Quản lý Profile

- 📸 Ảnh đại diện (Camera/Gallery)
- 📝 Thông tin cá nhân (Tên, Bio, Email, SĐT)
- 🎂 Ngày sinh, Chiều cao, Cân nặng
- 🏥 Tiền sử bệnh, Tình trạng sức khỏe
- 🌓 Chuyển đổi Dark/Light mode
- 🌍 Chuyển đổi ngôn ngữ (Việt/Anh)

**Tính năng đặc biệt:**
- Khi thay đổi thông tin quan trọng (tuổi, BMI) → Hỏi có muốn cập nhật thói quen không
- Health alert banner khi BMI không chuẩn

### 5. 🎨 Tính năng UX

- 🔔 Local notifications với lịch thông minh
- 📊 Biểu đồ và progress visualization
- 🎯 Streak tracking và milestone celebrations
- 🌈 Icon và color picker
- ⚡ Smooth animations
- 💾 Auto-save với SharedPreferences

---

## 🛠️ Công nghệ sử dụng

### Core Technologies

| Công nghệ | Version | Mục đích |
|-----------|---------|----------|
| **Flutter** | 3.9.0+ | Framework UI đa nền tảng |
| **Dart** | 3.9.0+ | Ngôn ngữ lập trình |
| **Material Design 3** | Latest | Design system |

### Dependencies

```yaml
dependencies:
  # State Management
  provider: ^6.1.2
  
  # UI Components
  google_fonts: ^6.2.1
  fl_chart: ^0.69.0
  flutter_svg: ^2.0.10+1
  
  # Storage
  shared_preferences: ^2.3.3
  path_provider: ^2.1.5
  
  # Utilities
  intl: ^0.20.2
  image_picker: ^1.1.2
  http: ^1.2.2
  
  # Notifications
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.4
  
  # Localization
  flutter_localizations:
    sdk: flutter
```

### Architecture

- **Pattern**: Provider (State Management)
- **Storage**: SharedPreferences (Local)
- **Notifications**: flutter_local_notifications
- **Internationalization**: flutter_localizations (l10n)

---

## 📥 Cài đặt

### Prerequisites

Đảm bảo máy tính đã cài đặt:

- ✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.9.0)
- ✅ [Dart SDK](https://dart.dev/get-dart) (>= 3.9.0)
- ✅ [Android Studio](https://developer.android.com/studio) hoặc [VS Code](https://code.visualstudio.com/)
- ✅ Android Emulator hoặc thiết bị thật

### Installation Steps

1️⃣ **Clone repository**

```bash
git clone <repository-url>
cd mobile
```

2️⃣ **Install dependencies**

```bash
flutter pub get
```

3️⃣ **Run the app**

```bash
# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

4️⃣ **Build APK (Android)**

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

5️⃣ **Build iOS (macOS only)**

```bash
flutter build ios --release
```

---

## 📂 Cấu trúc dự án

```
lib/
├── constants/
│   ├── app_constants.dart      # Colors, dimensions, shadows
│   ├── app_theme.dart          # Light & dark themes
│   └── habit_data.dart         # Icons, categories, colors
│
├── l10n/
│   ├── app_localizations.dart  # Localization base
│   ├── app_localizations_en.dart # English translations
│   ├── app_localizations_vi.dart # Vietnamese translations
│   ├── app_en.arb             # English resources
│   └── app_vi.arb             # Vietnamese resources
│
├── models/
│   ├── habit.dart             # Habit model
│   ├── user_profile.dart      # User profile model
│   └── bad_habit_challenge.dart # Bad habit challenge model
│
├── screens/
│   ├── welcome_screen.dart           # Onboarding/Welcome
│   ├── theme_loading_screen.dart     # Theme transition
│   ├── onboarding_profile_screen.dart # Profile setup
│   ├── onboarding_habit_screen.dart  # Habit setup
│   ├── current_habits_input_screen.dart # Current habits input
│   ├── suggested_habits_screen.dart  # Suggested habits
│   ├── habit_analysis_result_screen.dart # Analysis results
│   ├── home_screen.dart              # Main dashboard
│   ├── add_habit_screen.dart         # Add/Edit habits
│   ├── habit_detail_screen.dart      # Habit details & stats
│   ├── bad_habits_screen.dart        # Bad habits list
│   ├── bad_habit_progress_screen.dart # Bad habit tracking
│   ├── profile_screen.dart           # Profile & settings
│   ├── edit_profile_screen.dart      # Edit profile
│   ├── health_recommendations_screen.dart # Health suggestions
│   └── group_info_screen.dart        # About/Group info
│
├── utils/
│   ├── theme_provider.dart           # Theme state management
│   ├── language_provider.dart        # Language state
│   ├── user_provider.dart            # User profile state
│   ├── user_storage_service.dart     # User data storage
│   ├── habit_classifier.dart         # Habit classification
│   ├── habit_auto_classifier.dart    # Auto classification
│   ├── habit_contribution_service.dart # User contributions
│   ├── health_assessment_service.dart # Health assessment
│   └── bad_habit_notification_service.dart # Notifications
│
├── widgets/
│   ├── habit_card.dart         # Habit item card
│   └── progress_circle.dart    # Circular progress
│
└── main.dart                   # App entry point
```

### Key Files Explained

| File | Purpose |
|------|---------|
| `main.dart` | App initialization, providers setup |
| `app_theme.dart` | Light/Dark theme configuration |
| `habit.dart` | Habit data model with JSON serialization |
| `bad_habit_challenge.dart` | Challenge tracking for bad habits |
| `health_assessment_service.dart` | BMI calculation & health assessment |
| `bad_habit_notification_service.dart` | Smart notification scheduling |
| `user_storage_service.dart` | SharedPreferences wrapper |

---

## 📖 Hướng dẫn sử dụng

### 🎬 Onboarding Flow

1. **Welcome Screen** → Tap "Get Started"
2. **Profile Setup** → Nhập thông tin cá nhân (tên, tuổi, chiều cao, cân nặng)
3. **Health Assessment** → Tự động đánh giá BMI
4. **Habit Suggestions** → Chọn thói quen từ danh sách gợi ý
5. **Home Screen** → Bắt đầu sử dụng!

### 🌟 Thêm Thói quen Tốt

1. Tap **FAB (+)** ở Home Screen
2. Nhập tên thói quen
3. Chọn icon và màu
4. Chọn category
5. Đặt target minutes
6. Tap **"Add Habit"**

### 🚫 Bỏ Thói quen Xấu

1. Home Screen → Tap **"Thói quen cần bỏ"** banner
2. Chọn thói quen xấu → Tap **"Hành động ngay"**
3. Chọn mức độ cam kết:
   - 🐢 Từ từ (3-6 tháng)
   - 🚶 Vừa phải (1.5-3 tháng)
   - 🏃 Kiên quyết (15-30 ngày)
4. Chọn số ngày cam kết bằng slider
5. Xác nhận → Bắt đầu challenge!
6. Điểm danh mỗi ngày vào **22:00**

### 🏥 Xem Đánh giá Sức khỏe

1. Profile → Tap **Health Alert Banner** (nếu có)
2. Xem BMI, tuổi, và đánh giá
3. Đọc khuyến nghị
4. Chọn thói quen gợi ý
5. Tap **"Thêm X thói quen"**

---

## 📱 Screenshots

### Main Screens

| Welcome | Home | Habit Detail |
|---------|------|--------------|
| _[Screenshot 1]_ | _[Screenshot 2]_ | _[Screenshot 3]_ |

### Bad Habit Challenge

| Select Level | Progress Tracking | Completion |
|--------------|-------------------|------------|
| _[Screenshot 4]_ | _[Screenshot 5]_ | _[Screenshot 6]_ |

### Health Assessment

| Alert Banner | Recommendations | Add Habits |
|--------------|-----------------|------------|
| _[Screenshot 7]_ | _[Screenshot 8]_ | _[Screenshot 9]_ |

---

## 🏗️ Kiến trúc

### State Management Flow

```
┌─────────────────────────────────────────┐
│          MultiProvider (main.dart)       │
├─────────────────────────────────────────┤
│  - ThemeProvider                        │
│  - LanguageProvider                     │
│  - UserProvider                         │
└─────────────────────────────────────────┘
              │
              ├──> Consumer Widgets
              │    (UI automatically updates)
              │
              └──> Services
                   ├── UserStorageService
                   ├── HealthAssessmentService
                   └── BadHabitNotificationService
```

### Data Flow

```
User Input
    ↓
UI Screen
    ↓
Provider (State Management)
    ↓
Service Layer
    ↓
SharedPreferences (Storage)
```

### Notification System

```
Challenge Created
    ↓
BadHabitNotificationService.scheduleNotifications()
    ↓
Schedule based on level:
    ├── Từ từ: 1x/day at 6AM
    ├── Vừa phải: 2x/day at 6AM, 6PM
    └── Kiên quyết: Every 3 hours (6AM-12AM)
    ↓
+ 22:00 Daily Check-in Reminder (all levels)
```

---

## 🧪 Testing

### Manual Testing

```bash
# Run in debug mode with logs
flutter run --debug

# Run in profile mode (performance testing)
flutter run --profile

# Run tests
flutter test
```

### Test Scenarios

✅ **Habit CRUD**: Create, Read, Update, Delete habits  
✅ **Streak Calculation**: Verify streak counting logic  
✅ **BMI Assessment**: Test all BMI categories  
✅ **Challenge Completion**: Test 90% threshold  
✅ **Notifications**: Verify scheduling by level  
✅ **Dark Mode**: Toggle theme without crashes  
✅ **Language Switch**: Change language dynamically  
✅ **Profile Update**: Trigger health re-assessment  

---

## 📊 Thống kê dự án

| Metric | Value |
|--------|-------|
| **Total Lines of Code** | ~15,000+ |
| **Screens** | 15 |
| **Models** | 3 |
| **Services** | 6 |
| **Widgets** | 2+ |
| **Languages Supported** | 2 (EN, VI) |
| **Notification Types** | 4 |

---

## 🔮 Tính năng tương lai

### Phase 2
- [ ] Cloud sync with Firebase
- [ ] Social features (friends, leaderboard)
- [ ] Habit templates library
- [ ] Export data (PDF, CSV)
- [ ] Home screen widgets

### Phase 3
- [ ] AI-powered habit suggestions
- [ ] Integration with health apps (Google Fit, Apple Health)
- [ ] Habit groups & challenges
- [ ] Advanced analytics dashboard
- [ ] Paid premium features

---

## 👨‍💻 Đóng góp

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/ten-tinh-nang

# Make changes and commit
git add .
git commit -m "Add: Mô tả ngắn gọn"

# Push to remote
git push origin feature/ten-tinh-nang

# Create Pull Request on GitHub
```

### Commit Message Convention

```
Add: Thêm tính năng mới
Update: Cập nhật tính năng hiện có
Fix: Sửa lỗi
Refactor: Tái cấu trúc code
Docs: Cập nhật documentation
Test: Thêm/sửa tests
```

---

## 📄 License

This project was developed for **educational purposes** as part of a Mobile Application Development course.

**Copyright © 2025 - [Tên Nhóm]**

All rights reserved. This project is not for commercial use.

---

## 🙏 Acknowledgments

### Technologies & Libraries
- [Flutter](https://flutter.dev/) - UI framework
- [Provider](https://pub.dev/packages/provider) - State management
- [FL Chart](https://pub.dev/packages/fl_chart) - Beautiful charts
- [Google Fonts](https://pub.dev/packages/google_fonts) - Typography

### Design Inspiration
- Material Design 3 guidelines
- Popular habit tracking apps (Habitica, Streaks, Loop)
- WHO health standards

---

## 📚 Tài liệu kỹ thuật

### Feature Documentation

- [PROFILE_RECLASSIFY_FEATURE.md](PROFILE_RECLASSIFY_FEATURE.md) - Profile update & habit reclassification
- [BAD_HABIT_CHALLENGE_FEATURE.md](BAD_HABIT_CHALLENGE_FEATURE.md) - Bad habit challenge system v1
- [BAD_HABIT_CHALLENGE_V2.md](BAD_HABIT_CHALLENGE_V2.md) - Updated challenge system v2
- [HEALTH_ASSESSMENT_FEATURE.md](HEALTH_ASSESSMENT_FEATURE.md) - Health assessment & recommendations

### User Guides

- [ACCOUNT_SWITCHING_GUIDE.md](lib/utils/ACCOUNT_SWITCHING_GUIDE.md) - Multiple user accounts guide

---

<p align="center">
  <strong>🌱 Built with ❤️ using Flutter 🌱</strong>
  <br>
  <sub>Version 1.0.0 - November 2025</sub>
</p>

---

