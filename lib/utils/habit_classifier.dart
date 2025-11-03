class HabitClassifier {
  // Danh sách thói quen tốt (Good Habits) - Song ngữ Việt/English
  static const List<Map<String, dynamic>> goodHabits = [
    // Health - Sức khỏe
    {'vi': 'tập thể dục', 'en': 'exercise', 'category': 'Health'},
    {'vi': 'chạy bộ', 'en': 'running', 'category': 'Health'},
    {'vi': 'đi bộ', 'en': 'walking', 'category': 'Health'},
    {'vi': 'yoga', 'en': 'yoga', 'category': 'Health'},
    {'vi': 'uống nước', 'en': 'drink water', 'category': 'Health'},
    {'vi': 'ăn sáng', 'en': 'eat breakfast', 'category': 'Health'},
    {'vi': 'ăn trái cây', 'en': 'eat fruits', 'category': 'Health'},
    {'vi': 'ăn rau', 'en': 'eat vegetables', 'category': 'Health'},
    {'vi': 'ngủ đủ giấc', 'en': 'sleep enough', 'category': 'Health'},
    {'vi': 'đi ngủ sớm', 'en': 'sleep early', 'category': 'Health'},
    {'vi': 'dậy sớm', 'en': 'wake up early', 'category': 'Health'},
    {'vi': 'thiền', 'en': 'meditation', 'category': 'Health'},
    {'vi': 'thở sâu', 'en': 'deep breathing', 'category': 'Health'},
    {'vi': 'gym', 'en': 'gym', 'category': 'Health'},
    {'vi': 'bơi lội', 'en': 'swimming', 'category': 'Health'},
    {'vi': 'đạp xe', 'en': 'cycling', 'category': 'Health'},
    {'vi': 'nhảy dây', 'en': 'jump rope', 'category': 'Health'},
    {'vi': 'vệ sinh răng miệng', 'en': 'brush teeth', 'category': 'Health'},
    {'vi': 'rửa tay', 'en': 'wash hands', 'category': 'Health'},
    {'vi': 'tắm rửa', 'en': 'shower', 'category': 'Health'},
    
    // Study - Học tập
    {'vi': 'đọc sách', 'en': 'read books', 'category': 'Study'},
    {'vi': 'học bài', 'en': 'study', 'category': 'Study'},
    {'vi': 'viết nhật ký', 'en': 'journaling', 'category': 'Study'},
    {'vi': 'học ngoại ngữ', 'en': 'learn language', 'category': 'Study'},
    {'vi': 'học tiếng anh', 'en': 'learn english', 'category': 'Study'},
    {'vi': 'lập kế hoạch', 'en': 'planning', 'category': 'Study'},
    {'vi': 'ghi chú', 'en': 'take notes', 'category': 'Study'},
    {'vi': 'ôn tập', 'en': 'review', 'category': 'Study'},
    {'vi': 'làm bài tập', 'en': 'do homework', 'category': 'Study'},
    {'vi': 'nghiên cứu', 'en': 'research', 'category': 'Study'},
    {'vi': 'xem video học tập', 'en': 'watch educational videos', 'category': 'Study'},
    {'vi': 'học online', 'en': 'online learning', 'category': 'Study'},
    
    // Mind - Tinh thần
    {'vi': 'cảm ơn', 'en': 'gratitude', 'category': 'Mind'},
    {'vi': 'biết ơn', 'en': 'be thankful', 'category': 'Mind'},
    {'vi': 'suy ngẫm', 'en': 'reflection', 'category': 'Mind'},
    {'vi': 'tích cực', 'en': 'positive thinking', 'category': 'Mind'},
    {'vi': 'chánh niệm', 'en': 'mindfulness', 'category': 'Mind'},
    {'vi': 'ngồi thiền', 'en': 'meditation', 'category': 'Mind'},
    {'vi': 'thư giãn', 'en': 'relaxation', 'category': 'Mind'},
    {'vi': 'tự nhận thức', 'en': 'self awareness', 'category': 'Mind'},
    {'vi': 'tự khẳng định', 'en': 'affirmation', 'category': 'Mind'},
    
    // Work - Công việc
    {'vi': 'làm việc hiệu quả', 'en': 'productive work', 'category': 'Work'},
    {'vi': 'quản lý thời gian', 'en': 'time management', 'category': 'Work'},
    {'vi': 'tập trung', 'en': 'focus', 'category': 'Work'},
    {'vi': 'hoàn thành công việc', 'en': 'complete tasks', 'category': 'Work'},
    {'vi': 'làm việc sớm', 'en': 'work early', 'category': 'Work'},
    {'vi': 'dọn dẹp bàn làm việc', 'en': 'clean desk', 'category': 'Work'},
    {'vi': 'sắp xếp công việc', 'en': 'organize tasks', 'category': 'Work'},
    
    // Social - Xã hội
    {'vi': 'gọi điện cho gia đình', 'en': 'call family', 'category': 'Social'},
    {'vi': 'gặp gỡ bạn bè', 'en': 'meet friends', 'category': 'Social'},
    {'vi': 'giúp đỡ người khác', 'en': 'help others', 'category': 'Social'},
    {'vi': 'tình nguyện', 'en': 'volunteer', 'category': 'Social'},
    {'vi': 'kết nối', 'en': 'networking', 'category': 'Social'},
    {'vi': 'chia sẻ', 'en': 'sharing', 'category': 'Social'},
    {'vi': 'lắng nghe', 'en': 'listening', 'category': 'Social'},
    {'vi': 'giao tiếp', 'en': 'communication', 'category': 'Social'},
  ];

  // Danh sách thói quen xấu (Bad Habits) - Song ngữ Việt/English
  static const List<Map<String, dynamic>> badHabits = [
    // Health - Sức khỏe
    {'vi': 'hút thuốc', 'en': 'smoking', 'category': 'Health'},
    {'vi': 'uống rượu', 'en': 'drinking alcohol', 'category': 'Health'},
    {'vi': 'say rượu', 'en': 'getting drunk', 'category': 'Health'},
    {'vi': 'ăn vặt', 'en': 'snacking', 'category': 'Health'},
    {'vi': 'ăn đêm', 'en': 'late night eating', 'category': 'Health'},
    {'vi': 'ăn nhiều đường', 'en': 'eating sugar', 'category': 'Health'},
    {'vi': 'ăn đồ chiên', 'en': 'eating fried food', 'category': 'Health'},
    {'vi': 'uống nước ngọt', 'en': 'drinking soda', 'category': 'Health'},
    {'vi': 'thức khuya', 'en': 'stay up late', 'category': 'Health'},
    {'vi': 'ngủ muộn', 'en': 'sleep late', 'category': 'Health'},
    {'vi': 'thiếu ngủ', 'en': 'lack of sleep', 'category': 'Health'},
    {'vi': 'lười vận động', 'en': 'sedentary', 'category': 'Health'},
    {'vi': 'ngồi nhiều', 'en': 'sitting too much', 'category': 'Health'},
    {'vi': 'cắn móng tay', 'en': 'nail biting', 'category': 'Health'},
    {'vi': 'gãi đầu', 'en': 'scratching head', 'category': 'Health'},
    
    // Mind - Tinh thần
    {'vi': 'lo lắng', 'en': 'worrying', 'category': 'Mind'},
    {'vi': 'suy nghĩ tiêu cực', 'en': 'negative thinking', 'category': 'Mind'},
    {'vi': 'stress', 'en': 'stress', 'category': 'Mind'},
    {'vi': 'trì hoãn', 'en': 'procrastination', 'category': 'Mind'},
    {'vi': 'lười biếng', 'en': 'laziness', 'category': 'Mind'},
    {'vi': 'than phiền', 'en': 'complaining', 'category': 'Mind'},
    {'vi': 'nóng giận', 'en': 'getting angry', 'category': 'Mind'},
    {'vi': 'ghen tị', 'en': 'jealousy', 'category': 'Mind'},
    
    // Work - Công việc  
    {'vi': 'trì hoãn công việc', 'en': 'procrastinate work', 'category': 'Work'},
    {'vi': 'lãng phí thời gian', 'en': 'waste time', 'category': 'Work'},
    {'vi': 'làm việc vô tổ chức', 'en': 'unorganized work', 'category': 'Work'},
    {'vi': 'làm việc quá nhiều', 'en': 'overworking', 'category': 'Work'},
    {'vi': 'không tập trung', 'en': 'distraction', 'category': 'Work'},
    
    // Social - Xã hội
    {'vi': 'cô lập', 'en': 'isolation', 'category': 'Social'},
    {'vi': 'xa lánh', 'en': 'avoiding people', 'category': 'Social'},
    {'vi': 'nói xấu', 'en': 'gossiping', 'category': 'Social'},
    {'vi': 'tranh cãi', 'en': 'arguing', 'category': 'Social'},
    {'vi': 'cáu gắt', 'en': 'being rude', 'category': 'Social'},
    {'vi': 'phán xét', 'en': 'judging', 'category': 'Social'},
    
    // Technology - Công nghệ
    {'vi': 'nghiện điện thoại', 'en': 'phone addiction', 'category': 'Custom'},
    {'vi': 'xem điện thoại nhiều', 'en': 'excessive phone use', 'category': 'Custom'},
    {'vi': 'chơi game nhiều', 'en': 'gaming too much', 'category': 'Custom'},
    {'vi': 'lướt mạng xã hội', 'en': 'scrolling social media', 'category': 'Custom'},
    {'vi': 'xem tiktok', 'en': 'watching tiktok', 'category': 'Custom'},
    {'vi': 'xem youtube vô bổ', 'en': 'watching useless youtube', 'category': 'Custom'},
    {'vi': 'xem phim nhiều', 'en': 'binge watching', 'category': 'Custom'},
  ];

  /// Phân loại thói quen dựa trên tên
  /// Trả về: 'good', 'bad', hoặc 'uncertain'
  static String classifyHabit(String habitName) {
    final name = habitName.toLowerCase().trim();
    
    // Kiểm tra thói quen tốt
    for (var habit in goodHabits) {
      if (_matchesHabit(name, habit)) {
        return 'good';
      }
    }
    
    // Kiểm tra thói quen xấu
    for (var habit in badHabits) {
      if (_matchesHabit(name, habit)) {
        return 'bad';
      }
    }
    
    // Không chắc chắn
    return 'uncertain';
  }

  /// Tìm các gợi ý thói quen tương tự
  static List<Map<String, dynamic>> findSimilarHabits(String habitName) {
    final name = habitName.toLowerCase().trim();
    List<Map<String, dynamic>> suggestions = [];
    
    // Tìm trong thói quen tốt
    for (var habit in goodHabits) {
      if (_partialMatch(name, habit)) {
        suggestions.add({
          'habit': habit,
          'type': 'good',
          'displayName': habit['vi'],
        });
      }
    }
    
    // Tìm trong thói quen xấu
    for (var habit in badHabits) {
      if (_partialMatch(name, habit)) {
        suggestions.add({
          'habit': habit,
          'type': 'bad',
          'displayName': habit['vi'],
        });
      }
    }
    
    return suggestions;
  }

  /// Kiểm tra khớp chính xác hoặc gần giống
  static bool _matchesHabit(String name, Map<String, dynamic> habit) {
    final vi = habit['vi'].toString().toLowerCase();
    final en = habit['en'].toString().toLowerCase();
    
    // Khớp chính xác
    if (name == vi || name == en) return true;
    
    // Chứa toàn bộ từ khóa
    if (name.contains(vi) || name.contains(en)) return true;
    if (vi.contains(name) || en.contains(name)) return true;
    
    return false;
  }

  /// Kiểm tra khớp một phần (để gợi ý)
  static bool _partialMatch(String name, Map<String, dynamic> habit) {
    final vi = habit['vi'].toString().toLowerCase();
    final en = habit['en'].toString().toLowerCase();
    
    // Tách từ để so sánh
    final nameWords = name.split(' ');
    final viWords = vi.split(' ');
    final enWords = en.split(' ');
    
    // Kiểm tra nếu có từ chung
    for (var word in nameWords) {
      if (word.length < 2) continue; // Bỏ qua từ quá ngắn
      if (viWords.any((w) => w.contains(word) || word.contains(w))) return true;
      if (enWords.any((w) => w.contains(word) || word.contains(w))) return true;
    }
    
    return false;
  }

  /// Lấy thói quen tốt theo danh mục
  static List<Map<String, dynamic>> getGoodHabitsByCategory(String category) {
    return goodHabits.where((h) => h['category'] == category).toList();
  }

  /// Lấy thói quen xấu theo danh mục
  static List<Map<String, dynamic>> getBadHabitsByCategory(String category) {
    return badHabits.where((h) => h['category'] == category).toList();
  }
}
