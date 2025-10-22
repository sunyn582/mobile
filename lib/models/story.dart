import 'chapter.dart';

class Story {
  final int id;
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final List<String> genres;
  final List<Chapter> chapters;
  final int totalChapters;

  Story({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.genres,
    required this.chapters,
  }) : totalChapters = chapters.length;
}
