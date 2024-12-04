class LineParser {
  static final fieldRegexp = RegExp(r'^(event|data):(.*)$');
  static final commentRegexp = RegExp(r'^:');

  static bool isEvent(dataLine) =>
      _isField(dataLine) && field(dataLine) == 'event';

  static bool isData(dataLine) =>
      _isField(dataLine) && field(dataLine) == 'data';

  static bool isComment(dataLine) => commentRegexp.hasMatch(dataLine);

  static bool _isField(dataLine) => fieldRegexp.hasMatch(dataLine);

  static isEmptyLine(dataLine) => dataLine == "";

  static String? value(dataLine) {
    String match = fieldRegexp.firstMatch(dataLine)![2]!;
    return match == '' ? null : match;
  }

  static String field(dataLine) => fieldRegexp.firstMatch(dataLine)![1]!;
}
