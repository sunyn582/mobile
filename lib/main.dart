import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'constants/app_theme.dart';
import 'utils/theme_provider.dart';
import 'utils/language_provider.dart';
import 'utils/user_provider.dart';
import 'utils/user_storage_service.dart';
import 'screens/welcome_screen.dart';
import 'screens/theme_loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const HabitTrackerApp(),
    ),
  );
}

class HabitTrackerApp extends StatefulWidget {
  const HabitTrackerApp({super.key});

  @override
  State<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends State<HabitTrackerApp> {
  bool _isLoading = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    // Kiểm tra xem đây có phải lần đầu người dùng mở app không
    final isFirst = await UserStorageService.isFirstTimeUser();
    
    // Nếu không phải lần đầu, load thông tin người dùng đã lưu
    if (!isFirst) {
      final userProfile = await UserStorageService.getCurrentUser();
      if (userProfile != null && mounted) {
        // Load thông tin vào UserProvider
        context.read<UserProvider>().updateProfile(userProfile);
      }
    }
    
    if (mounted) {
      setState(() {
        _isFirstTime = isFirst;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Habit Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: languageProvider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          home: _isLoading
              ? ThemeLoadingScreen(
                  isDarkMode: themeProvider.themeMode == ThemeMode.dark,
                  onComplete: () {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ) // Màn hình loading
              : _isFirstTime
                  ? const WelcomeScreen(isFirstTime: true) // Người dùng mới
                  : const WelcomeScreen(isFirstTime: false), // Người dùng cũ
        );
      },
    );
  }
}
