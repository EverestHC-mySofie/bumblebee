import 'package:bumblebee/src/line_parser.dart';
import 'package:test/test.dart';

void main() {
  group('testing whether line is empty', () {
    test('it returns true if empty line', () {
      expect(LineParser.isEmptyLine(""), equals(true));
    });
    test('it returns false otherwise', () {
      expect(LineParser.isEmptyLine("x"), equals(false));
    });
  });

  group('testing whether line is an event', () {
    test('it returns true if the field is well formatted', () {
      expect(LineParser.isEvent("event:"), equals(true));
    });
    test('it returns false otherwise', () {
      expect(LineParser.isEvent("event"), equals(false));
    });
    test('it returns the field name', () {
      expect(LineParser.field("event:"), equals('event'));
    });

    test('it returns null for a field with an empty value', () {
      expect(LineParser.value("event:"), equals(null));
    });

    test('it returns the value', () {
      expect(LineParser.value("event:xxx"), equals('xxx'));
    });
  });

  group('testing whether line is a data field', () {
    test('it returns true if the field name is data', () {
      expect(LineParser.isData("data:"), equals(true));
    });
    test('it returns false otherwise', () {
      expect(LineParser.isData("event:"), equals(false));
    });
    test('it returns null for a data field with an empty value', () {
      expect(LineParser.value("data:"), equals(null));
    });

    test('it returns the value', () {
      expect(LineParser.value("data:xxx"), equals('xxx'));
    });
  });

  group('testing whether line is a comment', () {
    test('it returns true if the line is a comment', () {
      expect(LineParser.isComment(":"), equals(true));
      expect(LineParser.isComment(":x"), equals(true));
    });
    test('it returns false otherwise', () {
      expect(LineParser.isComment("x:"), equals(false));
    });
  });
}
