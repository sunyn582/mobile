# Habit Tracker App 🌱

A beautiful and minimal habit tracking application built with Flutter.

## 📱 About

**Habit Tracker** helps you build good habits, one day at a time. Track your daily progress, maintain streaks, and visualize your journey towards becoming a better you.

### ✨ Features

- **Daily Habit Tracking**: Mark habits as complete each day
- **Progress Visualization**: View weekly progress with beautiful charts
- **Streak Tracking**: See how many consecutive days you've maintained a habit
- **Custom Habits**: Create personalized habits with custom icons and colors
- **Categories**: Organize habits by Health, Study, Mind, Work, Social, or Custom
- **Reminders**: Set daily reminders for your habits (optional)
- **Statistics**: Detailed analytics and completion rates
- **Beautiful UI**: Clean, minimal design with smooth animations
- **Dark Mode**: Toggle between light and dark themes
- **Bilingual**: Support for English and Vietnamese

## 🎨 Design

### Color Palette
- Primary: Green (#6FCF97) - Fresh and inspiring
- Secondary: Blue (#2F80ED)
- Background: Light gradient (#F4F9F4 → White)

### Typography
- Headings: Poppins SemiBold
- Body: Nunito Regular

## 📂 Project Structure

```
lib/
 ├── constants/
 │   ├── app_constants.dart   # Colors, dimensions, shadows
 │   ├── app_theme.dart        # Light & dark themes
 │   └── habit_data.dart       # Icons, categories, colors
 ├── models/
 │   └── habit.dart            # Habit data model
 ├── screens/
 │   ├── welcome_screen.dart   # Splash/Welcome screen
 │   ├── home_screen.dart      # Main dashboard
 │   ├── add_habit_screen.dart # Add/Edit habits
 │   ├── habit_detail_screen.dart # Progress & statistics
 │   └── profile_screen.dart   # Settings & profile
 ├── widgets/
 │   ├── habit_card.dart       # Habit item card
 │   └── progress_circle.dart  # Circular progress indicator
 └── main.dart                 # App entry point
```

## 🛠️ Technologies

- **Framework**: Flutter 3.9.0+
- **Language**: Dart
- **UI Components**: Material Design 3
- **Charts**: fl_chart
- **Fonts**: Google Fonts (Poppins, Nunito)
- **Storage**: Shared Preferences (for local data)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd mobile
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Screens

### 1. Welcome Screen
- Animated logo with scale-in effect
- Inspiring slogan
- "Get Started" button with smooth transition

### 2. Home Screen (Dashboard)
- Greeting message based on time of day
- Today's progress indicator
- List of all habits with status
- Quick toggle for habit completion
- Floating action button to add new habits

### 3. Add/Edit Habit Screen
- Habit name input
- Icon picker (16 emoji options)
- Category selection
- Color picker (8 colors)
- Daily target slider (5-120 minutes)
- Optional reminder time

### 4. Habit Detail Screen
- Habit information card
- Streak counter
- Weekly completion rate
- 7-day bar chart
- Edit and delete options

### 5. Profile/Settings Screen
- User profile display
- Dark mode toggle
- Language toggle (English/Vietnamese)
- Project information
- About section

## 🎯 Key Features Explained

### Habit Model
- Unique ID for each habit
- Name, icon, category, color
- Target minutes per day
- Completion tracking by date
- Streak calculation
- Weekly completion rate

### Animations
- Scale animation on habit completion
- Fade-in transitions
- Smooth page transitions
- Animated progress indicators

### Data Persistence
Ready for implementation with:
- Shared Preferences for local storage
- JSON serialization/deserialization built-in
- Easy migration to SQLite or Firebase

## 👥 Project Information

- **Course**: Mobile Application Development
- **Student Name**: [Your Name]
- **Student ID**: [Your ID]
- **Instructor**: [Instructor Name]
- **Version**: 1.0.0

## 🔮 Future Enhancements

- [ ] Local database integration (SQLite)
- [ ] Cloud sync (Firebase)
- [ ] Push notifications for reminders
- [ ] More detailed statistics
- [ ] Habit templates
- [ ] Social features (share progress)
- [ ] Export data (PDF/CSV)
- [ ] Widgets for home screen

## 📄 License

This project was developed for educational purposes as part of a Mobile Development course.

## 🙏 Acknowledgments

- Google Fonts for typography
- FL Chart for beautiful visualizations
- Flutter community for amazing packages
- Inspiration from popular habit tracking apps

---

**Built with ❤️ using Flutter**
