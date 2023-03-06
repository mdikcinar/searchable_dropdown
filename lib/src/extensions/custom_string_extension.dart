extension CustomStringExtension on String {
  bool containsWithTurkishChars(String key) {
    return replaceTurkishChars.contains(key.replaceTurkishChars);
  }

  String get replaceTurkishChars {
    var replaced = toLowerCase();
    replaced = replaced.replaceAll('ş', 's');
    replaced = replaced.replaceAll('ı', 'i');
    replaced = replaced.replaceAll('ğ', 'g');
    replaced = replaced.replaceAll('ç', 'c');
    replaced = replaced.replaceAll('ö', 'o');
    replaced = replaced.replaceAll('ü', 'u');
    return replaced;
  }
}
