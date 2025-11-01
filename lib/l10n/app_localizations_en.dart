// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Habit Tracker';

  @override
  String get welcomeSlogan => 'Build good habits,\none day at a time.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get myHabits => 'My Habits';

  @override
  String get goodMorning => 'Good Morning! ☀️';

  @override
  String get goodAfternoon => 'Good Afternoon! 🌤️';

  @override
  String get goodEvening => 'Good Evening! 🌙';

  @override
  String get keepBuildingHabits => 'Keep building great habits!';

  @override
  String get todayProgress => 'Today\'s Progress';

  @override
  String get yourHabits => 'Your Habits';

  @override
  String get addNew => 'Add New';

  @override
  String get noHabitsYet => 'No habits yet';

  @override
  String get tapAddNewHabit => 'Tap \"Add New\" to create your first habit';

  @override
  String get addNewHabit => 'Add New Habit';

  @override
  String get editHabit => 'Edit Habit';

  @override
  String get save => 'Save';

  @override
  String get habitName => 'Habit Name';

  @override
  String get habitNameHint => 'e.g., Morning Meditation';

  @override
  String get pleaseEnterHabitName => 'Please enter a habit name';

  @override
  String get chooseIcon => 'Choose Icon';

  @override
  String get category => 'Category';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryStudy => 'Study';

  @override
  String get categoryMind => 'Mind';

  @override
  String get categoryWork => 'Work';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryCustom => 'Custom';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get dailyTarget => 'Daily Target';

  @override
  String get minutes => 'minutes';

  @override
  String get reminderOptional => 'Reminder (Optional)';

  @override
  String remindMeAt(String time) {
    return 'Remind me at $time';
  }

  @override
  String get setReminderTime => 'Set reminder time';

  @override
  String get createHabit => 'Create Habit';

  @override
  String get updateHabit => 'Update Habit';

  @override
  String get habitDetails => 'Habit Details';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get completion => 'Completion';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get habitInfo => 'Habit Info';

  @override
  String minutesPerDay(int minutes) {
    return '$minutes minutes/day';
  }

  @override
  String categoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String reminderLabel(String time) {
    return 'Reminder: $time';
  }

  @override
  String get deleteHabit => 'Delete Habit';

  @override
  String get deleteHabitConfirm =>
      'Are you sure you want to delete this habit?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get profileAndSettings => 'Profile & Settings';

  @override
  String get userName => 'User Name';

  @override
  String get buildingHabitsEveryDay => 'Building great habits every day';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchTheme => 'Switch between light and dark theme';

  @override
  String get language => 'English';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String get aboutThisProject => 'About This Project';

  @override
  String get project => 'Project';

  @override
  String get projectName => 'Habit Tracker App';

  @override
  String get course => 'Course';

  @override
  String get courseName => 'Mobile Application Development';

  @override
  String get studentName => 'Student Name';

  @override
  String get studentNamePlaceholder => 'Nguyễn Văn A';

  @override
  String get studentId => 'Student ID';

  @override
  String get studentIdPlaceholder => '2024XXXX';

  @override
  String get instructor => 'Instructor';

  @override
  String get instructorPlaceholder => 'Giảng viên hướng dẫn';

  @override
  String get version => 'Version';

  @override
  String get aboutApp =>
      'This project was developed for the Mobile Development course. It helps users track and build positive habits through daily consistency.';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpMessage =>
      'For help or support, please contact your instructor or visit the project documentation.';

  @override
  String get ok => 'OK';

  @override
  String minsPerDay(int mins) {
    return '$mins mins/day';
  }

  @override
  String get day => 'day';

  @override
  String get days => 'days';
}
