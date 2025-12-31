extension SimpleUzDateFormat on String? {
  static const _monthsUz = [
    '',
    'yanvar',
    'fevral',
    'mart',
    'aprel',
    'may',
    'iyun',
    'iyul',
    'avgust',
    'sentabr',
    'oktabr',
    'noyabr',
    'dekabr',
  ];

  String toUzDateTimeSimple() {
    if (this == null || this!.isEmpty) return '';

    try {
      final dt = DateTime.parse(this!).toLocal();

      final day = dt.day.toString().padLeft(2, '0');
      final month = _monthsUz[dt.month];
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');

      return '$day-$month, $year, $hour:$minute';
    } catch (_) {
      return '';
    }
  }
}

extension HtmlCleaner on String? {
  String removeHtmlTags() {
    if (this == null) return '';
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return this!.replaceAll(regex, '');
  }
}
