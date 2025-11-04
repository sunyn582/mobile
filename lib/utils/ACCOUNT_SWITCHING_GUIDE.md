# Hướng Dẫn Chuyển Đổi Giữa 3 Tài Khoản

## 📚 Tổng Quan

Hệ thống lưu trữ **3 loại tài khoản**:
1. **Current User** (Người đang dùng) - Tài khoản hiện tại
2. **Previous User** (Người cũ) - Tài khoản backup từ lần trước
3. **New User** (Người mới) - Tạo mới trong code

## 🗂️ Nơi Lưu Trữ

**SharedPreferences Keys:**
```dart
'current_user_profile'   // UserProfile JSON của người đang dùng
'previous_user_profile'  // UserProfile JSON của người cũ
'is_first_time'         // bool - Lần đầu sử dụng app?
```

## 🔧 API Sử dụng

### 1. Lấy Thông Tin Tài Khoản

```dart
import 'package:your_app/utils/user_storage_service.dart';

// Lấy người đang dùng
UserProfile? currentUser = await UserStorageService.getCurrentUser();
print('Current: ${currentUser?.name}');

// Lấy người cũ
UserProfile? previousUser = await UserStorageService.getPreviousUser();
print('Previous: ${previousUser?.name}');

// Kiểm tra tồn tại
bool hasCurrent = await UserStorageService.hasUserProfile();
bool hasPrevious = await UserStorageService.hasPreviousUser();
```

### 2. Lưu Tài Khoản Mới

```dart
// Tạo profile mới
final newUser = UserProfile(
  name: 'Nguyễn Văn C',
  bio: 'Building great habits',
);

// Lưu (người hiện tại sẽ TỰ ĐỘNG backup thành người cũ)
await UserStorageService.saveCurrentUser(newUser);

// Kết quả:
// - current_user = "Nguyễn Văn C" (mới)
// - previous_user = "Người cũ" (backup tự động)
```

### 3. Chuyển Đổi Tài Khoản

```dart
// CÁCH 1: Swap người cũ thành người hiện tại
await UserStorageService.switchToPreviousUser();

// CÁCH 2: Manual swap
final previousUser = await UserStorageService.getPreviousUser();
if (previousUser != null) {
  await UserStorageService.saveCurrentUser(previousUser);
}
```

### 4. Reset Tất Cả

```dart
// Xóa tất cả dữ liệu (về trạng thái lần đầu)
await UserStorageService.clearAllUserData();
```

## 💡 Ví Dụ Thực Tế

### Kịch bản 1: Test với 3 người dùng

```dart
// Lần 1: Tạo người A
final userA = UserProfile(name: 'Nguyễn Văn A', bio: 'User A');
await UserStorageService.saveCurrentUser(userA);
// Storage: current=A, previous=null

// Lần 2: Tạo người B
final userB = UserProfile(name: 'Trần Thị B', bio: 'User B');
await UserStorageService.saveCurrentUser(userB);
// Storage: current=B, previous=A (auto backup)

// Lần 3: Tạo người C
final userC = UserProfile(name: 'Lê Văn C', bio: 'User C');
await UserStorageService.saveCurrentUser(userC);
// Storage: current=C, previous=B (A bị mất)

// Chuyển về B
await UserStorageService.switchToPreviousUser();
// Storage: current=B, previous=C
```

### Kịch bản 2: Debug trong WelcomeScreen

```dart
// Trong welcome_screen.dart, hàm _loadExistingProfile()

Future<void> _loadExistingProfile() async {
  if (!widget.isFirstTime) {
    final current = await UserStorageService.getCurrentUser();
    final previous = await UserStorageService.getPreviousUser();
    
    // DEBUG: In ra console
    print('=== USER ACCOUNTS ===');
    print('Current: ${current?.name} - ${current?.email}');
    print('Previous: ${previous?.name} - ${previous?.email}');
    print('====================');
    
    // CHUYỂN ĐỔI: Uncomment dòng này để dùng người cũ
    // await UserStorageService.switchToPreviousUser();
    
    if (mounted) {
      setState(() {
        _existingProfile = current;
      });
    }
  }
}
```

### Kịch bản 3: Test nhanh trong main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TEST: Uncomment để reset về lần đầu
  // await UserStorageService.clearAllUserData();
  
  // TEST: Uncomment để tạo sẵn người dùng
  // final testUser = UserProfile(name: 'Test User', bio: 'Demo account');
  // await UserStorageService.saveCurrentUser(testUser);
  
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
```

## 🎯 Use Cases

### UC1: Reset về lần đầu (xóa tất cả user)
```dart
await UserStorageService.clearAllUserData();
// Restart app để thấy màn hình welcome cho người mới
```

### UC2: Tạo nhiều tài khoản test
```dart
// Tạo user 1
await UserStorageService.saveCurrentUser(
  UserProfile(name: 'User 1', bio: 'First user')
);

// Tạo user 2 (user 1 tự động thành previous)
await UserStorageService.saveCurrentUser(
  UserProfile(name: 'User 2', bio: 'Second user')
);

// Xem danh sách
final current = await UserStorageService.getCurrentUser();
final previous = await UserStorageService.getPreviousUser();
print('Current: ${current?.name}');
print('Previous: ${previous?.name}');
```

### UC3: Chuyển đổi giữa 2 user
```dart
// Ban đầu: current=A, previous=B

// Swap
await UserStorageService.switchToPreviousUser();
// Sau khi swap: current=B, previous=A

// Swap lại
await UserStorageService.switchToPreviousUser();
// current=A, previous=B
```

## ⚠️ Lưu Ý

1. **Chỉ lưu được tối đa 2 user** (current + previous)
2. **Backup tự động**: Khi lưu user mới, user hiện tại tự động thành previous
3. **User thứ 3 sẽ mất**: Nếu có A→B→C thì A sẽ bị xóa
4. **Không có UI chuyển đổi**: Phải chuyển trong code (phù hợp với app cá nhân)
5. **Testing**: Dùng `clearAllUserData()` để reset về trạng thái ban đầu

## 📝 Backward Compatibility

Code cũ vẫn hoạt động:
```dart
// Cũ (deprecated nhưng vẫn chạy)
await UserStorageService.saveUserProfile(profile);
final user = await UserStorageService.getUserProfile();

// Mới (khuyến nghị)
await UserStorageService.saveCurrentUser(profile);
final user = await UserStorageService.getCurrentUser();
```

## 🔍 Troubleshooting

**Q: Làm sao biết có bao nhiêu user đã lưu?**
```dart
final hasCurrent = await UserStorageService.hasUserProfile();
final hasPrevious = await UserStorageService.hasPreviousUser();
print('Total users: ${(hasCurrent ? 1 : 0) + (hasPrevious ? 1 : 0)}');
```

**Q: Làm sao xóa chỉ 1 user?**
```dart
// Không có API trực tiếp, nhưng có thể:
final prefs = await SharedPreferences.getInstance();
await prefs.remove('current_user_profile'); // Xóa current
await prefs.remove('previous_user_profile'); // Xóa previous
```

**Q: User bị mất khi tạo quá nhiều?**
```dart
// Đúng rồi! Chỉ lưu được 2 user gần nhất
// Nếu cần lưu nhiều hơn, phải mở rộng UserStorageService
```
