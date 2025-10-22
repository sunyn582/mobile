import 'package:flutter/material.dart';
import '../models/story.dart';

class ReadingScreen extends StatefulWidget {
  final Story story;
  final int initialChapterIndex;

  const ReadingScreen({
    super.key,
    required this.story,
    required this.initialChapterIndex,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late int currentChapterIndex;
  double fontSize = 18;

  @override
  void initState() {
    super.initState();
    currentChapterIndex = widget.initialChapterIndex;
  }

  void nextChapter() {
    if (currentChapterIndex < widget.story.chapters.length - 1) {
      setState(() {
        currentChapterIndex++;
      });
    }
  }

  void previousChapter() {
    if (currentChapterIndex > 0) {
      setState(() {
        currentChapterIndex--;
      });
    }
  }

  void increaseFontSize() {
    setState(() {
      if (fontSize < 32) fontSize += 2;
    });
  }

  void decreaseFontSize() {
    setState(() {
      if (fontSize > 12) fontSize -= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChapter = widget.story.chapters[currentChapterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentChapter.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: decreaseFontSize,
            tooltip: 'Giảm cỡ chữ',
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: increaseFontSize,
            tooltip: 'Tăng cỡ chữ',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chương ${currentChapterIndex + 1}/${widget.story.chapters.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentChapter.title,
                    style: TextStyle(
                      fontSize: fontSize + 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    currentChapter.content,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: currentChapterIndex > 0 ? previousChapter : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Chương trước'),
                ),
                ElevatedButton.icon(
                  onPressed: currentChapterIndex < widget.story.chapters.length - 1
                      ? nextChapter
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Chương sau'),
                  style: ElevatedButton.styleFrom(
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
