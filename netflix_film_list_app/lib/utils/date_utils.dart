// 📦 utils/date_utils.dart

bool isSeries(String title) {
  final lowered = title.toLowerCase();
  return lowered.contains("season") || lowered.contains("sezon");
}

String extractSeriesName(String fullTitle) {
  final parts = fullTitle.split(":");
  return parts.isNotEmpty ? parts.first.trim() : fullTitle;
}

String extractSeason(String fullTitle) {
  final regex = RegExp(r'(Season \d+|Sezon \d+)', caseSensitive: false);
  final match = regex.firstMatch(fullTitle);
  return match?.group(0)?.trim() ?? "Detay";
}

String convertDateFormat(String dateStr) {
  try {
    dateStr = dateStr.trim();

    final parts = dateStr.split('/');
    if (parts.length != 3) return dateStr;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) return dateStr;

    final parsedDate = DateTime.utc(2000 + year, month, day);
    final formatted =
        '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';

    return formatted;
  } catch (e) {
    return dateStr;
  }
}
