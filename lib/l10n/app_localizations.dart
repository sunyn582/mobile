import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Habit Tracker'**
  String get appTitle;

  /// Welcome screen slogan
  ///
  /// In en, this message translates to:
  /// **'Build good habits,\none day at a time.'**
  String get welcomeSlogan;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// My habits title
  ///
  /// In en, this message translates to:
  /// **'My Habits'**
  String get myHabits;

  /// Good morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning! ☀️'**
  String get goodMorning;

  /// Good afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon! 🌤️'**
  String get goodAfternoon;

  /// Good evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening! 🌙'**
  String get goodEvening;

  /// Motivational message
  ///
  /// In en, this message translates to:
  /// **'Keep building great habits!'**
  String get keepBuildingHabits;

  /// Today's progress title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todayProgress;

  /// Your habits section title
  ///
  /// In en, this message translates to:
  /// **'Your Habits'**
  String get yourHabits;

  /// Add new button
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get noHabitsYet;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add New\" to create your first habit'**
  String get tapAddNewHabit;

  /// Add new habit screen title
  ///
  /// In en, this message translates to:
  /// **'Add New Habit'**
  String get addNewHabit;

  /// Edit habit screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Habit'**
  String get editHabit;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Habit name label
  ///
  /// In en, this message translates to:
  /// **'Habit Name'**
  String get habitName;

  /// Habit name hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Morning Meditation'**
  String get habitNameHint;

  /// Validation message for habit name
  ///
  /// In en, this message translates to:
  /// **'Please enter a habit name'**
  String get pleaseEnterHabitName;

  /// Choose icon label
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get chooseIcon;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Health category
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// Study category
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get categoryStudy;

  /// Mind category
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get categoryMind;

  /// Work category
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// Social category
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// Custom category
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get categoryCustom;

  /// Choose color label
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// Daily target label
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTarget;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Reminder optional label
  ///
  /// In en, this message translates to:
  /// **'Reminder (Optional)'**
  String get reminderOptional;

  /// Remind me at time
  ///
  /// In en, this message translates to:
  /// **'Remind me at {time}'**
  String remindMeAt(String time);

  /// Set reminder time label
  ///
  /// In en, this message translates to:
  /// **'Set reminder time'**
  String get setReminderTime;

  /// Create habit button
  ///
  /// In en, this message translates to:
  /// **'Create Habit'**
  String get createHabit;

  /// Update habit button
  ///
  /// In en, this message translates to:
  /// **'Update Habit'**
  String get updateHabit;

  /// Habit details screen title
  ///
  /// In en, this message translates to:
  /// **'Habit Details'**
  String get habitDetails;

  /// Day streak label
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// Completion label
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// Weekly progress label
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// Habit info section title
  ///
  /// In en, this message translates to:
  /// **'Habit Info'**
  String get habitInfo;

  /// Minutes per day
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes/day'**
  String minutesPerDay(int minutes);

  /// Category label with value
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryLabel(String category);

  /// Reminder label with time
  ///
  /// In en, this message translates to:
  /// **'Reminder: {time}'**
  String reminderLabel(String time);

  /// Delete habit dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Habit'**
  String get deleteHabit;

  /// Delete habit confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this habit?'**
  String get deleteHabitConfirm;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// Profile and settings screen title
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileAndSettings;

  /// User name placeholder
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// User profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Building great habits every day'**
  String get buildingHabitsEveryDay;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Switch theme description
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark theme'**
  String get switchTheme;

  /// Language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Switch language description
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguage;

  /// About project section title
  ///
  /// In en, this message translates to:
  /// **'About This Project'**
  String get aboutThisProject;

  /// Project label
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// Project name
  ///
  /// In en, this message translates to:
  /// **'Habit Tracker App'**
  String get projectName;

  /// Course label
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// Course name
  ///
  /// In en, this message translates to:
  /// **'Mobile Application Development'**
  String get courseName;

  /// Student name label
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentName;

  /// Student name placeholder
  ///
  /// In en, this message translates to:
  /// **'Vũ Văn Sơn'**
  String get studentNamePlaceholder;

  /// Student ID label
  ///
  /// In en, this message translates to:
  /// **'Student ID'**
  String get studentId;

  /// Student ID placeholder
  ///
  /// In en, this message translates to:
  /// **'23010060'**
  String get studentIdPlaceholder;

  /// Instructor label
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// Instructor placeholder
  ///
  /// In en, this message translates to:
  /// **'Nguyễn Xuân Quế'**
  String get instructorPlaceholder;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// About app description
  ///
  /// In en, this message translates to:
  /// **'This project was developed for the Mobile Development course. It helps users track and build positive habits through daily consistency.'**
  String get aboutApp;

  /// Help and support button
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Help message
  ///
  /// In en, this message translates to:
  /// **'For help or support, please contact your instructor or visit the project documentation.'**
  String get helpMessage;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Mins per day in habit card
  ///
  /// In en, this message translates to:
  /// **'{mins} mins/day'**
  String minsPerDay(int mins);

  /// Single day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// Multiple days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Edit profile title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Change photo button
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Remove photo option
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Bio label
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// Validation message for name
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// Validation message for bio
  ///
  /// In en, this message translates to:
  /// **'Please enter your bio'**
  String get pleaseEnterBio;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email hint text
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Phone hint text
  ///
  /// In en, this message translates to:
  /// **'+84 123 456 789'**
  String get phoneHint;

  /// Validation message for email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// Group information title
  ///
  /// In en, this message translates to:
  /// **'Group Information'**
  String get groupInformation;

  /// View project details subtitle
  ///
  /// In en, this message translates to:
  /// **'View project and team details'**
  String get viewProjectDetails;

  /// Date of birth label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Select date button
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Medical history label
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// Medical history hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Allergies, chronic conditions, previous surgeries...'**
  String get medicalHistoryHint;

  /// Height label
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get height;

  /// Height hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., 170'**
  String get heightHint;

  /// Weight label
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// Weight hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., 65'**
  String get weightHint;

  /// Current health status label
  ///
  /// In en, this message translates to:
  /// **'Current Health Status'**
  String get currentHealthStatus;

  /// Health status hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Good, Recovering, Under treatment...'**
  String get healthStatusHint;

  /// Health information section title
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInformation;

  /// BMI label
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// Welcome back message for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Continue as existing user
  ///
  /// In en, this message translates to:
  /// **'Continue as {name}'**
  String continueAsUser(String name);

  /// Create new profile button
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// Enter name prompt
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Name input hint
  ///
  /// In en, this message translates to:
  /// **'e.g., John Doe'**
  String get yourNameHint;

  /// Let's start button for new users
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start!'**
  String get letsStart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
