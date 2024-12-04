import 'package:bumblebee/bumblebee.dart';
import 'package:test/test.dart';

void main() {
  final Event event = Event('type');

  test('it appends data', () {
    event.append("1");
    event.append(null);
    event.append("2");
    expect(event.data(), equals("12"));
  });
}
