part of 'package:bumblebee/bumblebee.dart';

class Event {
  final String? type;
  final List<String> _data = [];

  Event(this.type);

  append(String? chunk) {
    if (chunk != null) {
      _data.add(chunk);
    }
  }

  String data() => _data.join();
}
