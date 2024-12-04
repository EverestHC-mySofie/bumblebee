import 'package:bumblebee/bumblebee.dart';
import 'package:bumblebee/src/accumulator.dart';
import 'package:test/test.dart';

void main() {
  final Bridge bridge = Bridge();
  final Accumulator accumulator = Accumulator(bridge);

  group('testing comments', () {
    test('it fires onHearbeat', () {
      var callback = false;
      bridge.onHeartbeat = () => callback = true;
      accumulator.nextLine(":");
      expect(callback, equals(true));
      expect(accumulator.completionEvent, equals(null));
    });
  });

  group('testing events and data', () {
    test('it fires onMessage', () {
      var callback = false;
      bridge.onMessage = (Event event) {
        expect(event.type, equals('update'));
        expect(event.data(), equals('12'));
        callback = true;
      };
      accumulator.nextLine("event:update");
      accumulator.nextLine("data:1");
      accumulator.nextLine("data:2");
      accumulator.nextLine("");
      expect(callback, equals(true));
      expect(accumulator.completionEvent, equals(null));
    });
  });
}
