class ReadingTimeHelper {
  /// Calculate estimated reading time in minutes based on 200 words per minute.
  static int calculateReadingTime(String? content) {
    if (content == null || content.isEmpty) return 1;
    
    // Split by whitespace to count words
    final words = content.trim().split(RegExp(r'\s+')).length;
    
    // 200 wpm is the industry standard (Medium, etc.)
    final minutes = (words / 200).ceil();
    
    return minutes > 0 ? minutes : 1;
  }
}
